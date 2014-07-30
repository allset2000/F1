SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_LogJobDeliveryFailure] (
	 @JobId  int,
	 @ErrorStatus smallint,
	 @ErrorMessage varchar(250) = NULL,
	 @ExceptionMessage varchar(250) = NULL,
	 @DeliveryRuleId int = NULL
	 
) AS 
BEGIN
	IF EXISTS(select * from JobsDeliveryErrors where JobId = @JobId)
	BEGIN
		IF EXISTS(select * from JobsDeliveryErrors where JobId = @JobId and ErrorStatus = @ErrorStatus and ErrorMessage = @ErrorMessage)
		BEGIN
			UPDATE JobsDeliveryErrors set ChangedOn = GETDATE() where JobId = @JobId
		END
		ELSE
		BEGIN
			UPDATE JobsDeliveryErrors SET ErrorMessage = @ErrorMessage, ErrorStatus = @ErrorStatus, ExceptionMessage = @ExceptionMessage, ChangedOn = GETDATE() where JobId = @JobId

			INSERT INTO JobsDeliveryErrorsTracking(DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn)
			SELECT DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn FROM JobsDeliveryErrors where JobId = @JobId
			
		END
	END
	ELSE
	BEGIN
		INSERT INTO JobsDeliveryErrors(JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn)
		VALUES(@JobId,@DeliveryRuleId,@ErrorStatus,@ErrorMessage,@ExceptionMessage,GETDATE(),GETDATE())

    	INSERT INTO JobsDeliveryErrorsTracking(DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn)
		SELECT @@IDENTITY,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn FROM JobsDeliveryErrors where JobId = @JobId
	END
END


GO
