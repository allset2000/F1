SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteJobDeliveryWithNoRule] 
	-- Add the parameters for the stored procedure here
	@JobNumber varchar(20),
	@Method int
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM JobsToDeliver WHERE JobNumber=@JobNumber and Method=@Method and RuleName IS NULL
			INSERT INTO JobsDeliveryDeleted VALUES(@JobNumber,@Method,NULL, SUSER_NAME(), GETDATE())
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
