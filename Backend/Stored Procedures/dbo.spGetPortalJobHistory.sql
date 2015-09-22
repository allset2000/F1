/******************************          
** File:  spGetPortalJobHistory.sql          
** Name:  spGetPortalJobHistory          
** Desc:  Get the job history for given job number          
** Auth:  Suresh          
** Date:  8/Aug/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobHistory] 
(          
 @vvcrJobnumber VARCHAR(20)        
)           
AS          
BEGIN       
DECLARE @TempJobsHostory TABLE(  
 SgId int,
 JobHistoryID int,  
 StatusGroup varchar(255),  
 StatusDate datetime 
 )  


-- In Process Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=1 -- In Process Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Available for CR Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=2 -- Available for CR Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Corrected By CR Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=3 -- Corrected By CR Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Editing Complete Status
INSERT INTO @TempJobsHostory
SELECT jg.Id,Max(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=4 -- Editing Complete Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup
	
-- Delivered Status
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=5 -- Delivered Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

SELECT JH.JobNumber,JH.DocumentId,TJH.StatusGroup,JH.HistoryDateTime StatusDate,
		CASE  WHEN JH.JobType is NULL THEN jb.JobType ELSE JH.jobtype end JobType,JH.UserId,
		CASE WHEN JH.MRN IS NULL THEN JP.MRN ELSE JH.MRN END MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID
		FROM dbo.job_history JH  
		INNER JOIN jobs jb 
		ON jh.jobnumber=jb.jobnumber
		INNER JOIN @TempJobsHostory TJH
		ON TJH.JobHistoryID = JH.JobHistoryID
		LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON cast(JH.MRN AS VARCHAR)  = jp.MRN and  JH.jobnumber = jp.jobnumber 
		ORDER BY TJH.SgId ASC
END   

