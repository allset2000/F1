
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 --exec spGetPortalJobErrorHistoryByJobNumber '2016012000000004'
CREATE PROCEDURE [dbo].[spGetPortalJobErrorHistoryByJobNumber] 
(          
 @vvcrJobnumber VARCHAR(20)
)           
AS          
BEGIN    
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
	CurrentStatus int,
	IsError int
 ) 
  DECLARE @IsJobinHistory bit = 0
  DECLARE @ErrorGroupName VARCHAR(100)= (SELECT TOP 1 StatusGroup from JobStatusGroup WHERE Id=10) -- Indicates Error 
  -- nee to write logic to deside job has error or not
	
		INSERT INTO @TempJobsHostory
		  SELECT  JT.JobNumber,JH.DocumentID,@ErrorGroupName,A.ErrorDate AS StatusDate,JH.JobType,JH.UserId,JH.MRN,
				  JH.JobHistoryID,'',JH.CurrentStatus,1 as IsError
			FROM JobTracking JT  
			LEFT OUTER JOIN job_history JH on JT.jobnumber = JH.jobnumber and jt.status=JH.currentstatus
			INNER JOIN
			(
			  SELECT JOBNUMBER,MIN(ErrorDate) AS ErrorDate
				FROM
					(
						SELECT J.JOBNUMBER,MIN(J2DE.ErrorDate) AS ErrorDate 
						FROM jobstodeliver J2D 
						INNER JOIN JobsToDeliverErrors J2DE ON J2D.DeliveryID = J2DE.DeliveryID
						INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=J2DE.ErrorCode 
						INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType						
						INNER JOIN JOBS J ON j.jobnumber=j2d.jobnumber
						WHERE J.JobNumber=@vvcrJobnumber AND EST.ErrorSourceTypeID=1 -- CLIENT-DELIVERY ERRORs Only
						GROUP BY J.JOBNUMBER
					  UNION
						SELECT J.JOBNUMBER AS JOBNUMBER,MIN(EHJDE.FIRSTATTEMPT) AS ErrorDate
						FROM jobs J 
						INNER JOIN jobs_client JC ON J.jobnumber=JC.jobnumber
						INNER JOIN eh_jobs EHJ ON EHJ.jobnumber=JC.[FILENAME] 
						INNER JOIN eh_jobsdeliveryerrors EHJDE ON EHJDE.jobid=EHJ.jobid 
						INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=EHJDE.ErrorCode 
						INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType
						WHERE J.JobNumber=@vvcrJobnumber AND EST.ErrorSourceTypeID=1 --- CLIENT-DELIVERY ERRORs Only
						GROUP BY J.JOBNUMBER
					) A GROUP BY JOBNUMBER
				) A on A.Jobnumber=JT.JobNumber
			WHERE JT.JobNumber=@vvcrJobnumber 
			ORDER by JT.StatusDate ASC			
		

-- Get the jobtype, documentid and MRN from previous record in that group or get it from jobs and patient table.
		SELECT TOP 1 JH.JobNumber,
				doc.DocumentID,
				JH.StatusGroup,JH.StatusDate,
				CASE WHEN jt.JobType IS NULL or jt.JobType ='' THEN jb.JobType ELSE jt.JobType END JobType,
				un.UserId,
				CASE WHEN mr.MRN IS NULL THEN JP.MRN ELSE  mr.MRN END MRN,JP.FirstName,JP.MI,JP.LastName,jb.ClinicID,JH.JgId,IsError 
		FROM @TempJobsHostory as JH 
			INNER JOIN jobs jb ON jh.JobNumber=jb.JobNumber		
				OUTER APPLY  
					(SELECT TOP 1 DocumentID FROM @TempJobsHostory as b WHERE b.DocumentID IS NOT NULL ORDER BY b.JobHistoryID ASC) doc
				OUTER APPLY 
				   (SELECT TOP 1 MRN FROM @TempJobsHostory as b WHERE  b.MRN IS NOT NULL ORDER BY b.JobHistoryID ASC ) mr
				OUTER APPLY 
				   (SELECT TOP 1 JobType FROM @TempJobsHostory as b WHERE b.JobType IS NOT NULL AND  b.JobType <> '' ORDER BY b.JobHistoryID ASC  ) jt
				OUTER Apply
					(SELECT TOP 1 UserId FROM @TempJobsHostory as b WHERE b.UserId IS NOT NULL ORDER BY b.JobHistoryID ASC) un
				LEFT OUTER JOIN [dbo].[Jobs_Patients] JP ON JH.JobNumber=jp.JobNumber AND (mr.mrn=jp.mrn or mr.mrn IS NULL)	
		ORDER BY JH.StatusDate asc
END

GO
