/******************************          
** File:  spGetPortalJobHistoryByStatusGroupId.sql          
** Name:  spGetPortalJobHistoryByStatusGroupId          
** Desc:  Get the job history for given job number          
** Auth:  Suresh          
** Date:  28/Sep/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobHistoryByStatusGroupId]  
(          
 @vvcrJobnumber VARCHAR(20),
 @StatusGroupId int        
)           
AS          
BEGIN       

DECLARE @TempJobsHostory1 TABLE(  
	JobNumber VARCHAR(20),
	DocumentID int,  
	StatusGroup varchar(255), 
	StatusDate datetime, 
	JobType varchar(100),
	UserId VARCHAR(48),
	MRN int,
	JobHistoryID int,
	JgId int
 )  

	IF EXISTS(SELECT * FROM job_history JH
							INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=@StatusGroupId 
							INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId WHERE JobNumber=@vvcrJobnumber)
		BEGIN
		-- Get the max datetime history based on group by status 
		INSERT INTO @TempJobsHostory1
			SELECT JH.JobNumber,JH.DocumentID,JG.StatusGroup,JH.HistoryDateTime,JH.JobType,UserId,JH.MRN,JH.JobHistoryID,jg.id from 
							(SELECT h3.JobNumber, h3.JobHistoryID, h3.MRN, h3.JobType,h3.CurrentStatus,h3.DocumentID,h3.UserId, h3.HistoryDateTime 
							FROM (
								SELECT h.CurrentStatus, MAX(h.HistoryDateTime) AS StatusDate
								FROM dbo.job_history h
								WHERE h.JobNumber=@vvcrJobnumber
								GROUP BY h.CurrentStatus
								) h2 JOIN dbo.job_history h3
									ON h2.CurrentStatus = h3.CurrentStatus AND h2.StatusDate = h3.HistoryDateTime) JH
							INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=@StatusGroupId 
							INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		END
	ELSE
		BEGIN
		-- get the history from jobtracking table if history not avalable in job_history table
		INSERT INTO @TempJobsHostory1
			SELECT JH.JobNumber,null DocumentID,JG.StatusGroup,MAX(JH.StatusDate),null JobType,null UserId,null MRN,1 JobHistoryID,jg.id from JobTracking JH  
			INNER JOIN dbo.StatusCodes SC ON JH.Status= SC.StatusID
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=@StatusGroupId -- Editing Complete Status
			GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup
		END

-- Get the jobtype, documentid and MRN from previous record in that group or get it from jobs and patient table.
SELECT TOP 1 JH.JobNumber,
	doc.DocumentID,
	JH.StatusGroup,JH.StatusDate,
	CASE WHEN jh.JobType IS NULL THEN jb.JobType ELSE jh.JobType END JobType,
	UserId,
	CASE WHEN mr.MRN IS NULL THEN JP.MRN ELSE  mr.MRN END MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID,JH.JgId  FROM @TempJobsHostory1 as JH 
	OUTER APPLY  
        (SELECT TOP 1 DocumentID FROM @TempJobsHostory1 as b WHERE b.DocumentID IS NOT NULL ORDER BY b.JobHistoryID DESC) doc
	OUTER APPLY 
       (SELECT TOP 1 MRN FROM @TempJobsHostory1 as b WHERE  b.MRN IS NOT NULL ORDER BY b.JobHistoryID DESC) mr
	OUTER APPLY 
       (SELECT TOP 1 JobType FROM @TempJobsHostory1 as b WHERE b.JobType IS NOT NULL ORDER BY b.JobHistoryID DESC) jt
	INNER JOIN jobs jb 
		ON jh.JobNumber=jb.JobNumber
	LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON JH.JobNumber = jp.JobNumber
	ORDER BY JH.JobHistoryID
END