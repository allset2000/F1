
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spRemoveJobToDeliver.sql  
** Name:  spRemoveJobToDeliver  
** Desc:  Removed job from JobsToDelivery table 
** Auth:  Unknown
** Date:  Unknown
**************************  
** Change History  
	Modifiyed By: Mikayil Bayramov (Mika)
	Midification Date: 11/19/2015
	Modification Description: With previous implementation the job would be deleted form JobsToDeliver table on Entrada DB. 
							  In new implementation, the job is also deleted from JobsToDeliverErrors table on Entrada DB,
							  as well as JobsDeliveryErrors table on EntradaHostedClient DB
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[writeJ2D] (
	@JobNumber VARCHAR(20)
) AS 
BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION 
		
		DECLARE @deliveryID AS INT,
		        @clientJobNumber AS VARCHAR(30)

		--Get DeliveryID, we will need it later
		SELECT @deliveryID = DeliveryID 
		FROM [dbo].[JobsToDeliver] 
		WHERE JobNumber = @JobNumber

		--Get client job number, and again we will need it later
		SELECT @clientJobNumber = [FileName]
		FROM [dbo].[Jobs_Client] 
		WHERE JobNumber = @JobNumber

		--Remove record
		DELETE FROM [dbo].[JobsToDeliver] 
		WHERE JobNumber = @JobNumber

		--Remove any errors for the job to deliver, which was removed in the previous step
		DELETE FROM [dbo].[JobsToDeliverErrors]
		WHERE DeliveryID = @deliveryID

		--Remove any errors for the job to deliver, which was removed in the previous step
		--This time we do it on EntradaHostedClient DB
		DELETE FROM [dbo].[EH2_JobsDeliveryErrors]
		WHERE JobID = (SELECT JobID
		               FROM [dbo].[EH2_Jobs] 
					   WHERE JobNumber = @clientJobNumber)
		
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
END
GO
