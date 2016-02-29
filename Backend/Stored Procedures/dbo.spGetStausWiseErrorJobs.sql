/******************************          
** File:  spGetStausWiseErrorJobs.sql          
** Name:  spGetStausWiseErrorJobs          
** Desc:  Get the Error jobs based on status
** Auth:  Suresh          
** Date:  16/Feb/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spGetStausWiseErrorJobs] 
(
	 @vintStatus INT,
	 @vvcrSourceDB VARCHAR(20)
)           
AS          
BEGIN 
	
	IF @vvcrSourceDB = 'Hosted'
	BEGIN
		SELECT J.jobnumber,LC.LogExceptionID,SUBSTRING(LE.ExceptionMessage, 1, 200) ExceptionMessage,LE.LogConfigurationID
		FROM [dbo].[EH_Jobs] J
		INNER JOIN [dbo].EL_LogExceptionsCustomData LC
		on J.JobID = LC.JobID
		INNER JOIN EL_LogExceptions LE
		on LC.LogExceptionID = LE.LogExceptionID
		WHERE J.Status = @vintStatus 
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM dbo.JobStatusA WHERE Status=@vintStatus)
		BEGIN
			SELECT J.jobnumber,LC.LogExceptionID,SUBSTRING(LE.ExceptionMessage, 1, 200) ExceptionMessage,LE.LogConfigurationID
			FROM jobs J
			INNER JOIN dbo.JobStatusA JA
			ON J.jobnumber = JA.jobnumber
			INNER JOIN [dbo].EL_LogExceptionsCustomData LC
			on J.jobnumber = LC.jobnumber
			INNER JOIN EL_LogExceptions LE
			on LC.LogExceptionID = LE.LogExceptionID
			WHERE JA.Status = @vintStatus 
		END

		IF EXISTS (SELECT 1 FROM dbo.JobStatusB WHERE Status=@vintStatus)
		BEGIN
			SELECT J.jobnumber,LC.LogExceptionID,SUBSTRING(LE.ExceptionMessage, 1, 200) ExceptionMessage,LE.LogConfigurationID
			FROM jobs J
			INNER JOIN dbo.JobStatusB JB
			ON J.jobnumber = JB.jobnumber
			INNer JOIN [dbo].EL_LogExceptionsCustomData LC
			on J.jobnumber = LC.jobnumber
			INNER JOIN EL_LogExceptions LE
			on LC.LogExceptionID = LE.LogExceptionID
			WHERE JB.Status = @vintStatus 
		END
	END	
END

