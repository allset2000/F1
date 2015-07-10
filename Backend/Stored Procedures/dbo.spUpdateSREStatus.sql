/******************************      
** File:  spUpdateSREStatus.sql      
** Name:  spUpdateSREStatus      
** Desc:  Update the job status and add the record to jobtracking table      
** Auth:  Suresh      
** Date:  27/Mar/2015      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/
CREATE PROCEDURE [dbo].[spUpdateSREStatus]  
(  
 @vvcrJobNumber VARCHAR(20),  
 @vsintStatus SMALLINT,  
 @vvcrPath  VARCHAR(255)  
)  
AS  
BEGIN TRANSACTION  
	BEGIN TRY
		UPDATE  jobStatusA SET [Status] = @vsintStatus, StatusDate = GETDATE(), [Path] = @vvcrPath  
		WHERE JobNumber = @vvcrJobNumber  

		INSERT INTO JobTracking  
		VALUES (@vvcrJobNumber,@vsintStatus,GETDATE(),@vvcrPath )  
  
		IF @vsintStatus = 110  
		BEGIN  
		UPDATE jobs SET IsLockedForProcessing=0 where jobNumber=@vvcrJobNumber  
		END  
		COMMIT
	END TRY
BEGIN CATCH
	-- Rollback the transaction  
    ROLLBACK  
    -- Raise an error and return  
    RAISERROR ('Error in Insert or Update Status.', 16, 1)  
    RETURN  
END CATCH

