SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_DeleteJobs] 
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM JobTracking Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM JobStatusB Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM JobStatusA Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM Jobs_Custom Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM Jobs_Referring Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM Jobs_Patients Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM Jobs_Client Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
			DELETE FROM Jobs Where JobNumber IN (SELECT JobNumber FROM JobsToDelete)
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
