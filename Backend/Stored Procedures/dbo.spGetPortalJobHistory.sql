
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetPortalJobHistory.sql          
** Name:  spGetPortalJobHistory          
** Desc:  Get the job history for given job number          
** Auth:  Suresh          
** Date:  8/Aug/2015          
**************************          
** Change History          
*************************          
* PR   Date       Author    Description           
* --   --------   -------   ------------------------------------
*      2-Feb-2016  Baswaraj #393 Added a Column for ErrorHistoryIdentification   
*      18-Feb-2016 Baswaraj #393 added insert block to get override fields added values  
*      25-FEB-2016 Narender: #731# Added STAT Field to insert into Job History 
*      3-March-2016  : Added return UserName with Override values Added BY
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobHistory]  
(
 @vvcrJobnumber VARCHAR(20)        
)           
AS          
BEGIN       
DECLARE @TempJobsHostory1 TABLE(  
	JobNumber VARCHAR(20),
	DocumentID INT,  
	StatusGroup VARCHAR(255), 
	StatusDate DATETIME, 
	JobType VARCHAR(100),
	UserId VARCHAR(48),
	MRN VARCHAR(50),
	FirstName VARCHAR(50),
	MI VARCHAR(50),
	LastName VARCHAR(50),
	ClinicID SMALLINT,
	SgId INT,
	IsError INT -- To Identify the error existence in the job history page
 )  

 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,1 -- In Process Status 

 INSERT INTO @TempJobsHostory1  -- Draft Review 
 SELECT TOP 1 JH.JobNumber, JH.DocumentID, 'Draft Review', HistoryDateTime,
		 CASE WHEN JH.JobType IS NULL or JH.JobType ='' THEN J.JobType ELSE JH.JobType END JobType, UserId, JH.MRN, 
		 CASE WHEN JH.FirstName IS NULL or JH.FirstName ='' THEN JP.FirstName ELSE JH.FirstName END FirstName, 
		 CASE WHEN JH.MI IS NULL or JH.MI ='' THEN JP.MI ELSE JH.MI END MI, 
		 CASE WHEN JH.LastName IS NULL or JH.LastName ='' THEN JP.LastName ELSE JH.LastName END LastName, null, 6, 0  FROM Job_History JH
			INNER JOIN dbo.Jobs J ON J.JobNumber = JH.JobNumber
			INNER JOIN dbo.Jobs_Patients JP ON JP.JobNumber = J.JobNumber
		WHERE JH.JobNumber = @vvcrJobnumber AND JH.CurrentStatus = 136 ORDER BY JobHistoryID DESC
 
 INSERT INTO @TempJobsHostory1  -- Approved From Mobile By
 SELECT TOP 1 JobNumber,DocumentID, 'Approved From Mobile By', HistoryDateTime, JobType, UserId, MRN, FirstName, MI, LastName, null, 7, 0  FROM Job_History JH
		 WHERE JobNumber = @vvcrJobnumber AND JH.CurrentStatus = 138 AND  JH.IsFromMobile = 1 ORDER BY JobHistoryID DESC

 INSERT INTO @TempJobsHostory1  -- Send To Transcription By
 SELECT TOP 1 JobNumber,DocumentID, 'Send To Transcription By', HistoryDateTime, JobType, UserId, MRN, FirstName, MI, LastName, null, 4, 0  FROM Job_History JH
		 WHERE JobNumber = @vvcrJobnumber AND JH.CurrentStatus = 140 AND JH.IsFromMobile = 1 ORDER BY JobHistoryID DESC

 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,2 -- Available for CR Status 
 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,3 -- Corrected By CR Status 
 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,4 -- Editing Complete Status
 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,5 -- Delivered Status
 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobErrorHistoryByJobNumber] @vvcrJobnumber --  Error Message
 -- the below query to insert the override values #393
 INSERT INTO @TempJobsHostory1(JobNumber,StatusGroup,StatusDate,JobType,UserId,FirstName,LastName,SgId,IsError)
 
SELECT  rov.JobNumber,'Override Value Added By '+u.Name ,CASE WHEN rov.CreatedDate IS NULL THEN Getdate() ELSE rov.CreatedDate END
		 ,rof.FieldName,'','',rov.Value,0,CASE WHEN rov.IsActive IS NULL or rov.IsActive =1 THEN 2 ELSE 3 END IsError -- IF 2 it is Active and 3 It is InActive
		 FROM EH_ROWOverrideValues rov 
		 INNER JOIN EH_ROWOverrideFields rof ON rof.FieldID = rov.FieldID 
		 INNER JOIN EH_Users u ON u.UserID=rov.CreatedBY			                              
		 WHERE JobNumber= @vvcrJobnumber

 INSERT INTO @TempJobsHostory1  
 SELECT TOP 1 JobNumber,DocumentID, 'Job Marked as STAT',HistoryDateTime, null, UserId, null, null, null, null, null, SC.StatusGroupId, 0  FROM Job_History JH
		INNER JOIN StatusCodes  SC on SC.StatusID = JH.CurrentStatus WHERE JobNumber = @vvcrJobnumber AND  STAT = 1 ORDER BY JobHistoryID DESC
 SELECT * FROM @TempJobsHostory1 order by IsError,SgId,StatusDate  asc 

END
GO
