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
      @DeliveryId INT = NULL,
	  @Message VARCHAR(200) = NULL,
	  @ConfigurationName  VARCHAR(100) = NULL,      
      @ErrorId SMALLINT = NULL,	  
	  @ErrorMessage VARCHAR(200) = NULL,
      @ExceptionMessage VARCHAR(200) = NULL,
      @StackTrace VARCHAR(MAX) = NULL
      
)AS 
BEGIN	
	DECLARE @ErrorCode INT
	SET @ErrorCode = ISNULL((SELECT TOP 1 ED.ErrorCode from ENTRADAHOSTEDCLIENT.DBO.ErrorDefinitions ED where @Message like '%'+ED.ErrorMessage+'%'),5000)
	
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
