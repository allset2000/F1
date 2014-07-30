SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_UpdateJobTypeAndContext] 
	-- Add the parameters for the stored procedure here
	@JobNumber varchar(20),
	@NewJobType varchar(50)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE Jobs SET JobType=@NewJobType, ContextName=@NewJobType WHERE JobNumber=@JobNumber
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
GRANT EXECUTE ON  [dbo].[sp_UpdateJobTypeAndContext] TO [mmoscoso]
GRANT EXECUTE ON  [dbo].[sp_UpdateJobTypeAndContext] TO [rwilson]
GO
