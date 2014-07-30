SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doSignDocument] (
	@DocumentSignatureId  int,
	@AppliedDocSignatureRuleId	int,
	@DocSignatureMode char(1),
	@DocumentId int,
	@AppliedById int,
	@ESignature   [varchar] (1024),
	@JobNumber    [varchar] (20),
	@Document     varbinary(MAX),
	@Username     [varchar] (200),
	@NextSignerID [varchar] (50),
	@DocDate      [datetime]
) AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

			IF NOT EXISTS(SELECT * FROM [dbo].[DocumentSignatures] 
			              WHERE ([DocumentSignatureId] = @DocumentSignatureId))
				BEGIN
					INSERT INTO [DocumentSignatures]
					([DocumentSignatureId], [AppliedDocSignatureRuleId], [DocSignatureMode],
					 [DocumentId], [AppliedById], [ESignature], [ApplicationTime], [CancelationTime],
					 [SignatureStatus], [JobNumber], [AppliedBy])
					VALUES
					(@DocumentSignatureId, @AppliedDocSignatureRuleId, @DocSignatureMode, 
					 @DocumentId, @AppliedById, @ESignature, @DocDate, '2078-12-31', 
					 'A', @JobNumber, @Username)
				END
			ELSE 
				BEGIN
					UPDATE [DocumentSignatures]
					SET ApplicationTime = @DocDate,
						ESignature = @ESignature,
						SignatureStatus = 'A'
					WHERE (DocumentSignatureId = @DocumentSignatureId)
				END
			
			
			IF (@DocSignatureMode = 'S')
				BEGIN						
					/* Update Document Status */
					UPDATE Jobs 
				    SET DocumentStatus = 160
					WHERE JobNumber = @JobNumber;
					
					/* This Insert statement only works in the new version March/6th/2012 */
					IF NOT EXISTS(SELECT * FROM [dbo].[DocumentsToProcess] WHERE [JobNumber] = @JobNumber)
						BEGIN
							INSERT INTO DocumentsToProcess 
							([JobNumber])
							VALUES 
							(@JobNumber)
						END
				END
			ELSE IF (@DocSignatureMode = 'R')
				BEGIN
					INSERT INTO [DocumentSignatures]
					([DocumentSignatureId], [AppliedDocSignatureRuleId], [DocSignatureMode],
					 [DocumentId], [AppliedById], [ESignature], [ApplicationTime], [CancelationTime],
					 [SignatureStatus], [JobNumber], [AppliedBy])
					VALUES
					(@DocumentSignatureId + 1, @AppliedDocSignatureRuleId, 'S', 
					 @DocumentId, @AppliedById, '', '2078-12-31', '2078-12-31', 
					 'P', @JobNumber, @NextSignerID)
				
					UPDATE Jobs 
					SET DocumentStatus = 155
					WHERE JobNumber = @JobNumber;
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
