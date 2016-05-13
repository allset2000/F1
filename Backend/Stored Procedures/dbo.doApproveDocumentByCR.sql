
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doApproveDocumentByCR] (
	@JobNumber  [varchar]  (20),
	@Document   varbinary(MAX),
	@Username   [varchar]  (200),
	@Timestamp  [datetime]	
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
			
			INSERT INTO Job_History
			(JobNumber, MRN, CurrentStatus, FirstName, MI, LastName, DOB, HistoryDateTime,DocumentID,UserId)
			select @JobNumber,MRN,@Status,FirstName, MI, LastName, DOB,GETDATE(),@documentID,@oldUsername FROM Jobs_patients WHERE Jobnumber = @JobNumber 

		/* Update Job Document */							
		UPDATE Jobs_Documents
			SET Doc = @Document,
					Username = @Username,
					DocDate = @Timestamp 
		WHERE JobNumber = @JobNumber;  
         
		UPDATE JobStatusA 
		SET [Status] = 250, 
		StatusDate = @Timestamp
		WHERE JobNumber = @JobNumber;

		INSERT INTO [dbo].[JobTracking]
		([JobNumber], [Status], [StatusDate], [Path])		
		SELECT [JobNumber], [Status], [StatusDate], [Path] 
		FROM [dbo].JobStatusA
		WHERE (JobNumber = @JobNumber)

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
