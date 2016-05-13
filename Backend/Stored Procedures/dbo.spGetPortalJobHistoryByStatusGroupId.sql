
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetPortalJobHistoryByStatusGroupId.sql          
** Name:  spGetPortalJobHistoryByStatusGroupId          
** Desc:  Get the job history for given job number          
** Auth:  Suresh          
** Date:  28/Sep/2015          
**************************          
** Change History          
*************************          
* PR   Date       Author    Description           
* --   --------   -------   ------------------------------------ 
* #393 2-Feb-2016 Baswaraj  Added "0 as isError" retrun calumn in select for know it is not error history         
* #731 25-FEB-2016 Narender Added STAT Field to insert into Job History 
* #4832 11-APR-2016 Narender Updated for Job Resend Feature
 EXEC spGetPortalJobHistoryByStatusGroupId 2016020500000001,4
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
	MRN varchar(50),
	JobHistoryID int,
	JgId int,
	CurrentStatus INT,
	AppointmentDate SMALLDATETIME,
	DOB SMALLDATETIME,
	FirstName varchar(50),
	MI varchar(50),
	LastName varchar(50)
 )  

  Declare @IsJobinHistory bit = 0
 SELECT @IsJobinHistory = 1 FROM job_history JH
			 				INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID and sc.StatusGroupId=@StatusGroupId 
							INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId WHERE JobNumber=@vvcrJobnumber AND jh.STAT IS NULL


 	IF @IsJobinHistory =1 AND @StatusGroupId <> 5
		BEGIN
		-- Get the history based status group id 
		INSERT INTO @TempJobsHostory
			SELECT TOP 1  JT.JobNumber,JH.DocumentID,JG.StatusGroup,JT.StatusDate,JH.JobType,JH.UserId,JH.MRN,JH.JobHistoryID,jg.id,JH.CurrentStatus,
			JH.AppointmentDate,JH.DOB,JH.FirstName,JH.MI,JH.LastName  
			FROM JobTracking JT  
			INNER JOIN dbo.StatusCodes SC ON JT.Status= SC.StatusID
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			LEFT OUTER JOIN job_history JH on JT.jobnumber = JH.jobnumber and JT.status=JH.currentstatus 
			WHERE JT.JobNumber=@vvcrJobnumber and sc.StatusGroupId=@StatusGroupId AND jh.STAT IS NULL AND JH.JobHistoryID IS NOT NULL AND IsHistory = 1
			ORDER by JT.StatusDate ASC
			END
	ELSE IF @StatusGroupId = 5 --Delivered
		BEGIN
		-- get the Delivered history from JobDeliveryHistory table, if job is deliverd to customer
		INSERT INTO @TempJobsHostory
			SELECT JT.JobNumber, JH.DocumentID,'Delivered' StatusGroup,jd.DeliveredOn StatusDate,JH.JobType,JH.UserId,JH.MRN,1 JobHistoryID,jg.id,null CurrentStatus,
			JH.AppointmentDate,JH.DOB,JH.FirstName,JH.MI,JH.LastName 
			FROM JobTracking JT 
			INNER JOIN dbo.StatusCodes SC ON JT.Status= SC.StatusID and sc.StatusGroupId = 5  AND SC.StatusID = 360
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			INNER JOIN JobDeliveryHistory JD ON JD.jobnumber=JT.jobnumber
			left outer join job_history JH on JT.jobnumber = JH.jobnumber and jt.status=JH.currentstatus AND JD.JobHistoryID = JH.JobHistoryID
			WHERE JT.JobNumber=@vvcrJobnumber and IsHistory = 1
			ORDER BY jg.id DESC
		END
	ELSE 
		BEGIN
		-- get the history from jobtracking table if history not avalable in job_history table
		INSERT INTO @TempJobsHostory
			SELECT top 1 JH.JobNumber,null DocumentID,JG.StatusGroup,min(JH.StatusDate),JobType,null UserId,null MRN,1 JobHistoryID,jg.id,null CurrentStatus,
			j.AppointmentDate+j.AppointmentTime as AppointmentDate, DOB, FirstName, MI, LastName from JobTracking JH   
			INNER JOIN dbo.StatusCodes SC ON JH.Status= SC.StatusID
			INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
			INNER JOIN jobs j on j.Jobnumber = jh.jobnumber
			INNER JOIN Jobs_patients jp on jp.jobnumber = j.jobnumber 
			WHERE JH.JobNumber=@vvcrJobnumber and sc.StatusGroupId=@StatusGroupId 
			GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup,JobType,AppointmentDate,AppointmentTime,DOB,FirstName,MI,LastName
		END

-- Get the jobtype, documentid and MRN from previous record in that group or get it from jobs and patient table.
 IF @StatusGroupId = 5
	BEGIN
		SELECT JH.JobNumber,
	JH.DocumentID,
	JH.StatusGroup,JH.StatusDate,
	CASE WHEN JH.JobType IS NULL or JH.JobType ='' THEN jb.JobType ELSE JH.JobType END JobType,
	JH.UserId,
	CASE WHEN JH.MRN IS NULL THEN JP.MRN ELSE  JH.MRN END MRN,
	CASE WHEN JH.FirstName IS NULL or JH.FirstName =''  THEN JP.FirstName ELSE  JH.FirstName END FirstName,
	CASE WHEN JH.MI IS NULL or JH.MI =''  THEN JP.MI ELSE  JH.MI END MI,
	CASE WHEN JH.LastName IS NULL or JH.LastName =''  THEN JP.LastName ELSE  JH.LastName END LastName,
	jb.ClinicID,JH.JgId, 0 as isError, -- added this to represent that it is not error history
	CASE WHEN JH.AppointmentDate IS NULL or JH.AppointmentDate ='' THEN jb.AppointmentDate + jb.AppointmentTime ELSE JH.AppointmentDate END AppointmentDate,
	CASE WHEN JH.DOB IS NULL or JH.DOB ='' THEN JP.DOB ELSE JH.DOB END DOB
	FROM @TempJobsHostory as JH 
	INNER JOIN jobs jb ON jh.JobNumber=jb.JobNumber
	LEFT OUTER JOIN [dbo].[Jobs_Patients] JP ON JH.JobNumber = jp.JobNumber 
	ORDER BY JH.StatusDate asc
	END
 ELSE
	BEGIN		
		SELECT JH.JobNumber,
	doc.DocumentID,
	JH.StatusGroup,JH.StatusDate,
	CASE WHEN jt.JobType IS NULL or jt.JobType ='' THEN jb.JobType ELSE jt.JobType END JobType,
	un.UserId,
	CASE WHEN mr.MRN IS NULL THEN JP.MRN ELSE  mr.MRN END MRN,
	CASE WHEN JH.FirstName IS NULL or JH.FirstName =''  THEN JP.FirstName ELSE  JH.FirstName END FirstName,
	JH.MI,
	CASE WHEN JH.LastName IS NULL or JH.LastName =''  THEN JP.LastName ELSE  JH.LastName END LastName,
	jb.ClinicID,JH.JgId, 0 as isError, -- added this to represent that it is not error history
	JH.AppointmentDate,JH.DOB
	FROM @TempJobsHostory as JH 
	OUTER APPLY  
        (SELECT TOP 1 DocumentID FROM @TempJobsHostory as b WHERE b.DocumentID IS NOT NULL ORDER BY b.JobHistoryID ASC) doc
	OUTER APPLY 
       (SELECT TOP 1 MRN FROM @TempJobsHostory as b WHERE  b.MRN IS NOT NULL ORDER BY b.JobHistoryID ASC ) mr
	OUTER APPLY 
       (SELECT TOP 1 JobType FROM @TempJobsHostory as b WHERE b.JobType IS NOT NULL AND  b.JobType <> '' ORDER BY b.JobHistoryID ASC  ) jt
	OUTER Apply
		(SELECT TOP 1 UserId FROM @TempJobsHostory as b WHERE b.UserId IS NOT NULL ORDER BY b.JobHistoryID ASC) un
	INNER JOIN jobs jb 
		ON jh.JobNumber=jb.JobNumber
	LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON JH.JobNumber = jp.JobNumber  and (mr.mrn=jp.mrn or mr.mrn is null)
	ORDER BY JH.StatusDate ASC
	END
END
GO
