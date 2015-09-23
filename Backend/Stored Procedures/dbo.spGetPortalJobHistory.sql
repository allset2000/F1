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
 StatusDate datetime,
 JOBNUMBER VARCHAR(20),
 FromHistory bit
 )  

 DECLARE @TempJobsHostory1 TABLE(  
JOBNUMBER VARCHAR(20),
 DocumentID int,  
 StatusGroup varchar(255), 
  StatusDate datetime, 
 JobType varchar(100),
 UserId VARCHAR(48),
 MRN int,
 FirstName VARCHAR(50),
 MI VARCHAR(50),
 LastName VARCHAR(50),
 ClinicID smallint,
 SgId int
 )  

-- In Process Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup, MAX(JH.HistoryDateTime) StatusDate,JH.jobnumber,1 from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber AND sc.StatusGroupId=1 -- In Process Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Available for CR Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate,JH.jobnumber,1  from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=2 -- Available for CR Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Corrected By CR Status 
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate,JH.jobnumber,1  from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=3 -- Corrected By CR Status 
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

-- Editing Complete Status
INSERT INTO @TempJobsHostory
SELECT jg.Id,Max(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate,JH.jobnumber,1  from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=4 -- Editing Complete Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

IF NOT EXISTS(SELECT * FROM @TempJobsHostory WHERE SgId = 4)
	BEGIN
	INSERT INTO @TempJobsHostory
	SELECT jg.Id,null JobHistoryID, JG.StatusGroup,MAX(JH.StatusDate) StatusDate,JH.jobnumber,0  from JobTracking JH  
		INNER JOIN dbo.StatusCodes SC ON JH.Status= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=4 -- Editing Complete Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup
	END
	
-- Delivered Status
INSERT INTO @TempJobsHostory
SELECT jg.Id,MAX(JH.JobHistoryID) JobHistoryID,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate,JH.jobnumber,1  from job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=5 -- Delivered Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup

IF NOT EXISTS(SELECT * FROM @TempJobsHostory WHERE SgId = 5)
	BEGIN
	INSERT INTO @TempJobsHostory
	SELECT jg.Id,null JobHistoryID, JG.StatusGroup,MAX(JH.StatusDate) StatusDate,JH.jobnumber,0  from JobTracking JH  
		INNER JOIN dbo.StatusCodes SC ON JH.Status= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=5 -- Editing Complete Status
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup
	END

INSERT INTO @TempJobsHostory1
SELECT JH.JobNumber,JH.DocumentId,TJH.StatusGroup,
		CASE WHEN JH.HistoryDateTime IS NULL THEN TJH.StatusDate ELSE JH.HistoryDateTime END StatusDate,
		CASE  WHEN JH.JobType is NULL THEN jb.JobType ELSE JH.jobtype end JobType,JH.UserId,
		CASE WHEN JH.MRN IS NULL THEN JP.MRN ELSE JH.MRN END MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID,TJH.sgid
		FROM dbo.job_history JH  
		INNER JOIN jobs jb 
		ON jh.jobnumber=jb.jobnumber
		inner JOIN @TempJobsHostory TJH
		ON TJH.JobHistoryID = JH.JobHistoryID
		and TJH.FromHistory=1
		LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON JH.jobnumber = jp.jobnumber

INSERT INTO @TempJobsHostory1
SELECT TJH.JobNumber,null DocumentId,TJH.StatusGroup,
		TJH.StatusDate StatusDate,
		jb.JobType JobType,null UserId,
		JP.MRN MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID,TJH.sgid
		from jobs jb 
		inner JOIN @TempJobsHostory TJH
		ON TJH.jobnumber = jb.jobnumber
		and TJH.FromHistory=0
		LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON jb.jobnumber = jp.jobnumber 

select * from @TempJobsHostory1 order by sgid asc

END