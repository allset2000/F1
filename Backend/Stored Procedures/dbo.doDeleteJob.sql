SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[doDeleteJob] 
	-- Add the parameters for the stored procedure here
	@JobNumber varchar(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM JobTracking Where JobNumber=@JobNumber
			DELETE FROM JobStatusB Where JobNumber=@JobNumber
			DELETE FROM JobStatusA Where JobNumber=@JobNumber
			DELETE FROM Jobs_Custom Where JobNumber=@JobNumber
			DELETE FROM Jobs_Referring Where JobNumber=@JobNumber
			DELETE FROM Jobs_Patients Where JobNumber=@JobNumber
			DELETE FROM Jobs_Client Where JobNumber=@JobNumber
			DELETE FROM Jobs Where JobNumber=@JobNumber
			INSERT INTO JobsDeleted VALUES(@JobNumber, SUSER_NAME(), GETDATE())
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
