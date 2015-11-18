SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spRemoveJobToDeliver.sql  
** Name:  spRemoveJobToDeliver  
** Desc:  Removed job from JobsToDelivery and JobsToDeliveryErrors tables 
** Auth:  Mikayil Bayramov (mika)  
** Date:  11/17/2015
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spRemoveJobToDeliver] ( 
	@deliveryID AS INT
)  
AS  
BEGIN TRY 
	BEGIN TRANSACTION 

	DELETE FROM [dbo].[JobsToDeliver] 
	WHERE DeliveryID = @deliveryID

	DELETE FROM [dbo].[JobsToDeliverErrors]
	WHERE DeliveryID = @deliveryID

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
			ROLLBACK TRANSACTION

			DECLARE @errMsg nvarchar(4000), @errSeverity int

			SELECT @errMsg = ERROR_MESSAGE(), @errSeverity = ERROR_SEVERITY()

			RAISERROR(@errMsg, @errSeverity, 1)
		END
END CATCH 

GO
