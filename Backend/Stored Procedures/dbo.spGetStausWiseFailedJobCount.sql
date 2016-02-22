SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetStausWithFailedJobs.sql          
** Name:  spGetStausWithFailedJobs          
** Desc:  Get the Failure jobs ccount and error count based on status Wise
** Auth:  Suresh          
** Date:  16/Feb/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spGetStausWiseFailedJobCount] 
(
	 @vintFaileCount INT    
)           
AS          
BEGIN 
	DECLARE @TempJobs TABLE(  
	 Status Int,  
	 [SourceDb] varchar(50),  
	 FailureCount int,  
	 ErrorCount int 
	 ) 
	 
	 -- Get the failur and error count for status from Hosted DB
	 INSERT INTO @TempJobs 
		SELECT STATUS,'Hosted',COUNT(j.jobid) FailureCount,COUNT(LG.[LogExceptionsCustomDataID]) ErroCount
		FROM [dbo].[EH_Jobs] J
		LEFT OUTER JOIN  [dbo].EL_LogExceptionsCustomData LG
			ON j.jobid = lg.jobid
		WHERE processfailurecount > @vintFaileCount
		GROUP BY STATUS

	-- Get the failur and error count for 150 status from Bacend DB
    INSERT INTO @TempJobs 
		SELECT ja.status,'Backend', COUNT(j.jobnumber) FailureCount,COUNT(LG.[LogExceptionsCustomDataID]) ErroCount
		FROM jobs j
		INNER JOIN jobstatusa ja
		ON j.jobnumber = ja.jobnumber
		LEFT OUTER join [dbo].EL_LogExceptionsCustomData LG
		on j.jobnumber = lg.jobnumber
		WHERE ja.STATUS=150 OR j.ProcessFailureCount >= @vintFaileCount
		GROUP BY ja.status

	-- Get the failur and error count for other status from Bacend DB
    INSERT INTO @TempJobs
		SELECT jb.status,'Backend', COUNT(j.jobnumber) FailureCount,COUNT(LG.[LogExceptionsCustomDataID]) ErroCount
		FROM jobs j
		INNER JOIN jobstatusb jb
		ON j.jobnumber = jb.jobnumber
		LEFT OUTER JOIN [dbo].EL_LogExceptionsCustomData LG
		on j.jobnumber = lg.jobnumber
		WHERE j.ProcessFailureCount >= @vintFaileCount
		GROUP BY jb.status

	SELECT * FROM @TempJobs

END




GO
