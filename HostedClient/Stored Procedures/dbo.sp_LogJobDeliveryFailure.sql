SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[sp_LogJobDeliveryFailure](
      @JobId  int,
      @ErrorStatus smallint,
      @ErrorMessage varchar(250)= NULL,
      @ExceptionMessage varchar(250)= NULL,
      @DeliveryRuleId int = NULL
      
)AS 
BEGIN		
	  -- Finding ErrorCode for the Error Message (5000 ErrorCode incase no Match found with Error Message) and inserting that one to JobsDeliveryErrors table
	  DECLARE @ErrorCode INT
	  set @ErrorCode = ISNULL((SELECT TOP 1 ErrorCode from ErrorDefinitions where @ErrorMessage like '%'+ErrorDefinitions.ErrorMessage+'%'),5000)	  

      IF EXISTS(select* from JobsDeliveryErrors where JobId = @JobId)
      BEGIN
            IF EXISTS(select* from JobsDeliveryErrors where JobId = @JobId and ErrorStatus = @ErrorStatus and ErrorMessage = @ErrorMessage)
            BEGIN
                  UPDATE JobsDeliveryErrors set ChangedOn = GETDATE() where JobId = @JobId
            END
            ELSE
            BEGIN				  
                  UPDATE JobsDeliveryErrors SET ErrorMessage = @ErrorMessage, ErrorStatus = @ErrorStatus, ExceptionMessage = @ExceptionMessage, ChangedOn = GETDATE(), ErrorCode = @ErrorCode where JobId = @JobId
 
                  INSERT INTO JobsDeliveryErrorsTracking(DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn,ErrorCode)
                  SELECT DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn,ErrorCode FROM JobsDeliveryErrors where JobId = @JobId
                  
            END
      END
      ELSE
      BEGIN
            INSERT INTO JobsDeliveryErrors(JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn,ErrorCode)
            VALUES(@JobId,@DeliveryRuleId,@ErrorStatus,@ErrorMessage,@ExceptionMessage,GETDATE(),GETDATE(),@ErrorCode)
 
			INSERT INTO JobsDeliveryErrorsTracking(DeliveryErrorId,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn,ErrorCode)
            SELECT @@IDENTITY,JobId,DeliveryRuleId,ErrorStatus,ErrorMessage,ExceptionMessage,FirstAttempt,ChangedOn,ErrorCode FROM JobsDeliveryErrors where JobId = @JobId
      END
END
 


GO
