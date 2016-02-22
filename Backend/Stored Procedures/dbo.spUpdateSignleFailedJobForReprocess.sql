SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetResetFailedJob.sql          
** Name:  spGetResetFailedJob          
** Desc:  Reset THE failed job for reprocess based on job number
** Auth:  Suresh          
** Date:  16/Feb/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spUpdateSignleFailedJobForReprocess] 
(
	 @vvcrjobNumber VARCHAR(20)
)           
AS          
BEGIN 
	
	UPDATE dbo.Jobs SET ProcessFailureCount=0 WHERE JobNumber = @vvcrjobNumber
	
	-- Reset the failed jobs for reprocess based on job number and status=150 in backend db
    IF EXISTS(SELECT 1 FROM dbo.JobStatusA WHERE JobNumber=@vvcrjobNumber AND Status=150)
		BEGIN 
			UPDATE dbo.Jobs SET	IsLockedForProcessing = 0
			WHERE JobNumber=@vvcrjobNumber

			UPDATE dbo.jobstatusa SET Status = 110 
			WHERE JobNumber = @vvcrjobNumber
		END	
	
END




GO
