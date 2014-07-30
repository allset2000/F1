SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[doUnsignDocument] (
	@DocumentSignatureId  int,
	@JobNumber    [varchar] (20),
	@Document     varbinary(MAX),
	@Username     [varchar] (200),
	@DocDate      [datetime]
) AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

			DECLARE @NewDocumentStatus smallint

			UPDATE DocumentSignatures
			SET CancelationTime = @DocDate,
				SignatureStatus = 'X',
				@NewDocumentStatus = CASE DocumentSignatureRules.DocSignatureRuleType WHEN 'D' THEN 155 ELSE 150 END
			FROM  DocumentSignatures INNER JOIN DocumentSignatureRules
			ON DocumentSignatures.AppliedDocSignatureRuleId = DocumentSignatureRules.DocSignatureRuleId
			WHERE (DocumentSignatureId = @DocumentSignatureId)

			/* Update Document Status */
			UPDATE Jobs 
		    SET DocumentStatus = @NewDocumentStatus 
			WHERE JobNumber = @JobNumber;							


			IF (@NewDocumentStatus = 155)
			BEGIN
				DECLARE @newDocSignatureId int
				SELECT @newDocSignatureId = MAX([DocumentSignatureId]) FROM [DocumentSignatures]
				
				INSERT INTO [DocumentSignatures]
				([DocumentSignatureId], [AppliedDocSignatureRuleId], [DocSignatureMode],
				 [DocumentId], [AppliedById], [ESignature], [ApplicationTime], [CancelationTime],
				 [SignatureStatus], [JobNumber], [AppliedBy])
				SELECT @newDocSignatureId + 1, AppliedDocSignatureRuleId, 'S', 
				 DocumentId, AppliedById, '', '2078-12-31', '2078-12-31', 
				 'P', @JobNumber, AppliedBy
				FROM [DocumentSignatures]
				WHERE (DocumentSignatureId = @DocumentSignatureId)
            END
            
			/* Insert Job History */
			INSERT INTO [dbo].[Jobs_Documents_History] (
				[JobNumber], [Doc], [XmlData], [Username], [DocDate]
			) SELECT JobNumber, Doc, XmlData, Username, DocDate 
			  FROM Jobs_Documents
			  WHERE (JobNumber = @JobNumber);

			/* Update Job Document */
			UPDATE Jobs_Documents
				SET Doc = @Document,
					Username = @Username,
					DocDate = @DocDate 
			WHERE JobNumber = @JobNumber;
    	     
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
			ROLLBACK TRANSACTION
				DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
				SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		   END
	END CATCH
	RETURN
END
GO
