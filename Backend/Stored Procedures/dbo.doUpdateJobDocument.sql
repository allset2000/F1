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
	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
						
			/* Insert Job History */
			INSERT INTO [dbo].[Jobs_Documents_History] (
				[JobNumber], [Doc], [XmlData], [Username], [DocDate]
			) SELECT JobNumber, Doc, XmlData, Username, DocDate 
				FROM Jobs_Documents WHERE (JobNumber = @JobNumber);

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
