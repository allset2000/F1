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

DECLARE @oldStatusDate DATETIME
 
DECLARE @TempJobsHostory TABLE(  
	JobNumber VARCHAR(20),
	DocumentID int,  
	StatusGroup varchar(255), 
	StatusDate datetime, 
	JobType varchar(100),
	UserId VARCHAR(48),
	MRN int,
	JobHistoryID int,
	JgId int,
	CurrentStatus int
 )  

 	IF EXISTS (SELECT 1 FROM job_history JH
			 				INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=@StatusGroupId 
							INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId WHERE JobNumber=@vvcrJobnumber) AND @StatusGroupId <> 5
		BEGIN
		-- Get the history based status group id 
		INSERT INTO @TempJobsHostory
			SELECT JH.JobNumber,JH.DocumentID,JG.StatusGroup,JH.HistoryDateTime,JH.JobType,UserId,JH.MRN,JH.JobHistoryID,jg.id,JH.CurrentStatus 
			FROM dbo.job_history JH
			INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=@StatusGroupId 
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			WHERE jh.jobnumber=@vvcrJobnumber

			-- getting actual statusdate for available CR from jobtracking
			IF @StatusGroupId=2
				BEGIN
					SELECT @oldStatusDate=Max(StatusDate) FROM jobtracking WHERE jobnumber=@vvcrJobnumber and status=240 GROUP BY status
					UPDATE @TempJobsHostory SET StatusDate=@oldStatusDate WHERE CurrentStatus=240
				END
			END
	ELSE IF @StatusGroupId = 5 -- Delivered
		BEGIN
		-- get the Delivered history from JobDeliveryHistory table, if job is deliverd to customer
		INSERT INTO @TempJobsHostory
			SELECT JT.JobNumber,null DocumentID,JG.StatusGroup,JH.StatusDate ,JH.JobType,JH.UserId,JH.MRN,JH.JobHistoryID,jg.id,JH.CurrentStatus  
			FROM JobTracking JT 
			outer apply(SELECT max(jd.DeliveredOn) StatusDate,JH.JobType,JH.UserId,JH.MRN,JH.JobHistoryID,jg.id,JH.CurrentStatus
						FROM dbo.job_history JH 
						INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=5 
						INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
						INNER JOIN JobDeliveryHistory JD ON JD.jobnumber=JH.jobnumber
							WHERE JH.jobnumber=@vvcrJobnumber
							GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup,JH.JobType,JH.UserId,JH.MRN,JH.JobHistoryID,jg.id,JH.CurrentStatus ) JH
			INNER JOIN dbo.StatusCodes SC ON JT.Status= SC.StatusID and sc.StatusGroupId=5 
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			WHERE JT.JobNumber=@vvcrJobnumber 

		END
	ELSE 
		BEGIN
		-- get the history from jobtracking table if history not avalable in job_history table
		INSERT INTO @TempJobsHostory
			SELECT JH.JobNumber,null DocumentID,JG.StatusGroup,MAX(JH.StatusDate),null JobType,null UserId,null MRN,1 JobHistoryID,jg.id,null CurrentStatus  from JobTracking JH  
			INNER JOIN dbo.StatusCodes SC ON JH.Status= SC.StatusID
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=@StatusGroupId 
			GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup
		END

-- Get the jobtype, documentid and MRN from previous record in that group or get it from jobs and patient table.
SELECT TOP 1 JH.JobNumber,
	doc.DocumentID,
	JH.StatusGroup,JH.StatusDate,
	CASE WHEN jt.JobType IS NULL or jt.JobType ='' THEN jb.JobType ELSE jt.JobType END JobType,
	un.UserId,
	CASE WHEN mr.MRN IS NULL THEN JP.MRN ELSE  mr.MRN END MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID,JH.JgId  FROM @TempJobsHostory as JH 
	OUTER APPLY  
        (SELECT TOP 1 DocumentID FROM @TempJobsHostory as b WHERE b.DocumentID IS NOT NULL ORDER BY b.JobHistoryID ASC) doc
	OUTER APPLY 
       (SELECT TOP 1 MRN FROM @TempJobsHostory as b WHERE  b.MRN IS NOT NULL ORDER BY case when @StatusGroupId =2 then b.JobHistoryID end asc, case when @StatusGroupId <> 2 then b.JobHistoryID end desc ) mr
	OUTER APPLY 
       (SELECT TOP 1 JobType FROM @TempJobsHostory as b WHERE b.JobType IS NOT NULL AND  b.JobType <> '' ORDER BY case when @StatusGroupId =2 then b.JobHistoryID end asc, case when @StatusGroupId <> 2 then b.JobHistoryID end DESC  ) jt
	OUTER Apply
		(SELECT TOP 1 UserId FROM @TempJobsHostory as b WHERE b.UserId IS NOT NULL ORDER BY b.JobHistoryID DESC) un
	INNER JOIN jobs jb 
		ON jh.JobNumber=jb.JobNumber
	LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON JH.JobNumber = jp.JobNumber  and (mr.mrn=jp.mrn or mr.mrn is null)
	ORDER BY JH.CurrentStatus desc
END
