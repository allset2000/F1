SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doUpdateJobDocument] (
	@JobNumber  [varchar]  (20),
	@Document   varbinary(MAX),
	@Username   [varchar]  (200),
	@DocDate    [datetime] 
) AS
BEGIN
	
	 DECLARE @DocumentId INT
	 DECLARE @Status INT 
	 DECLARE @oldUsername VARCHAR(48)

	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		SELECT @Status=Status,@oldUsername=Username FROM Jobs_Documents WHERE (JobNumber = @JobNumber);		
		/* Insert Job History */
		INSERT INTO [dbo].[Jobs_Documents_History] (
			[JobNumber], [Doc], [XmlData], [Username], [DocDate], [Status], [TemplateName],[StatusDate]
		) SELECT Jobs_Documents.JobNumber, Doc, XmlData, Username, DocDate ,jobs.JobStatus,jobs.TemplateName, Jobs_Documents.StatusDate
			FROM Jobs_Documents 
			INNER JOIN Jobs ON Jobs_Documents.JobNumber=jobs.JobNumber
			WHERE (Jobs_Documents.JobNumber = @JobNumber);
			
			/* Tracking into job history table */
			SELECT @DocumentId = IDENT_CURRENT('Jobs_Documents_History')
			EXEC spInsertJobHistory @JobNumber,null,null,@Status,@documentID,@oldUsername

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
