/******************************      
** File:  spRevertJobStatusForBBNMonitor.sql      
** Name:  spRevertJobStatusForBBNMonitor      
** Desc:  Update the job status in Jobs Table     
** Auth:  Suresh      
** Date:  25/Jun/2015      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/
CREATE PROCEDURE [dbo].[spRevertJobStatusForBBNMonitor] 
(    
@vvcrJobNumber VARCHAR(20),
@vintNumTries INT
)     
AS    
BEGIN TRANSACTION  
	BEGIN TRY
	UPDATE jobs SET JobStatus = 130 WHERE JobNumber =  @vvcrJobNumber AND JobStatus=135

	IF EXISTS(select JobNumber from  RecognitionFailedJobs WHERE JobNumber =  @vvcrJobNumber)
		UPDATE	RecognitionFailedJobs SET NumTries = @vintNumTries WHERE JobNumber =  @vvcrJobNumber
	ELSE
		INSERT INTO RecognitionFailedJobs(JobNumber,NumTries)  VALUES(@vvcrJobNumber,@vintNumTries)  
	
	COMMIT
END TRY
BEGIN CATCH
	-- Rollback the transaction  
    ROLLBACK  
    -- Raise an error and return  
    RAISERROR ('Error in Insert or Update Status.', 16, 1)  
    RETURN  
END CATCH
