
/******************************          
** File:  spGetEditorsForJob.sql          
** Name:  spGetEditorsForJob          
** Desc:  ser the Data base comapatibility level to 2008 or 2014 and get editor jobs
** Auth:  Suresh          
** Date:  20/Nov/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/   
CREATE PROCEDURE [dbo].[qryspGetEditorsForJob](
	@vintClinicId INT,
	@vintDictatorId INT,
	@vvcrJobsFilter VARCHAR(100)
)
AS
BEGIN
	
	SELECT DISTINCT QueueWorkspaceId, MAX(EditorIdOk) AS EditorIdOk 
	FROM vwQueueModel WHERE ClinicId IN(-1, @vintClinicId) AND DictatorId IN (-1, @vintDictatorId) AND QueueId <> -1 
	AND QueueWorkspaceId <> -1 AND QueueMemberId <> -1 AND EditorIdOk <> -1 AND EditorStatus = 'A' 
	AND (JobsFilter = '' OR JobsFilter LIKE @vvcrJobsFilter) 
	GROUP BY QueueWorkspaceId
	OPTION (QUERYTRACEON 9481)-- 2312 (SQl Server 2014) normally enables the new CE 
	-- the 2312 hint is canceled by the 9481 trace flag, the legacy CE is still used.

END
