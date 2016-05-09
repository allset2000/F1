
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/******************************          
** File:  spGetResetFailedJobsforReprocess.sql          
** Name:  spGetResetFailedJobsforReprocess          
** Desc:  Reset all failed jobs for reprocess based on status
** Auth:  Suresh          
** Date:  16/Feb/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spUpdateFailedJobsforReprocess] 
(
	 @vintStatus INT,
	 @vintFaileCount INT
)           
AS          
BEGIN 
	
	-- Reset all failed jobs for reprocess based on status 150 in backend db
    IF @vintStatus =150
	BEGIN 
		UPDATE dbo.Jobs SET	IsLockedForProcessing = 0, ProcessFailureCount=0,JobStatus=@vintStatus,JobStatusDate=GETDATE()
		FROM jobs j
		INNER JOIN jobstatusa ja
		ON j.JobNumber=ja.JobNumber
		WHERE ja.STATUS=150 
		
		UPDATE dbo.jobstatusa SET Status = 110
		FROM jobstatusa ja
		WHERE ja.STATUS=150
	END	

	-- Reset all failed jobs for reprocess based on status other than 150 in backend db
    IF @vintStatus <> 150
	BEGIN 
		UPDATE dbo.Jobs SET ProcessFailureCount=0,JobStatus=@vintStatus,JobStatusDate=GETDATE()
		FROM jobs j
		INNER JOIN dbo.JobStatusA ja
		ON j.jobnumber = ja.jobnumber
		WHERE j.ProcessFailureCount >= @vintFaileCount AND ja.Status = @vintStatus

		UPDATE dbo.Jobs SET ProcessFailureCount=0,JobStatus=@vintStatus,JobStatusDate=GETDATE()
		FROM jobs j
		INNER JOIN dbo.JobStatusB jb
		ON j.jobnumber = jb.jobnumber
		WHERE j.ProcessFailureCount >= @vintFaileCount AND jb.Status = @vintStatus
	END		
END





GO
