SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ReProcessVoice] 
	 @JobNumber  varchar(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @StatusJob smallint;
			SET @StatusJob = dbo.ftGetStatusJob(@JobNumber);
			IF (@StatusJob=150 OR @StatusJob=130 OR @StatusJob=120)
			BEGIN
				UPDATE JobStatusA SET [Status]=110 WHERE JobNumber=@JobNumber
			END
			ELSE
			BEGIN
				RAISERROR('Invalid Status', 1, 1)
			END
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
