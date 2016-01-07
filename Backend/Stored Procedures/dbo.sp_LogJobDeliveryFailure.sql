SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 12/31/2015    
-- Description: SP used to log Job Delivery Failure errors
-- =============================================    
CREATE PROCEDURE [dbo].[sp_LogJobDeliveryFailure](
      @ConfigurationName  VARCHAR(100) = NULL,
      @DeliveryId INT = NULL,
      @ErrorId SMALLINT = NULL,
	  @Message VARCHAR(200) = NULL,
	  @ErrorMessage VARCHAR(200),
      @ExceptionMessage VARCHAR(200) = NULL,
      @StackTrace VARCHAR(MAX) = NULL
      
)AS 
BEGIN	
	DECLARE @ErrorCode INT
	SET @ErrorCode = ISNULL((SELECT TOP 1 ED.ErrorCode from ENTRADAHOSTEDCLIENT.DBO.ErrorDefinitions ED where @ErrorMessage like '%'+ED.ErrorMessage+'%'),5000)
	
	INSERT INTO [dbo].[JobsToDeliverErrors]
			   ([ConfigurationName]
			   ,[DeliveryId]
			   ,[ErrorId]
			   ,[ErrorDate]
			   ,[Message]
			   ,[ErrorMessage]
			   ,[ExceptionMessage]
			   ,[StackTrace]
			   ,[ErrorCode])
		 VALUES
			   (@ConfigurationName
			   ,@DeliveryId
			   ,@ErrorId
			   ,GETDATE()
			   ,@Message
			   ,@ErrorMessage
			   ,@ExceptionMessage
			   ,@StackTrace
			   ,@ErrorCode)
END
GO
