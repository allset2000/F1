
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
	MRN INT,
	FirstName VARCHAR(50),
	MI VARCHAR(50),
	LastName VARCHAR(50),
	ClinicID SMALLINT,
	SgId INT,
	IsError INT -- To Identify the error existence in the job history page
 )  

 INSERT INTO @TempJobsHostory1
 EXEC [spGetPortalJobHistoryByStatusGroupId] @vvcrJobnumber,1 -- In Process Status 
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
 SELECT TOP 1 JobNumber,DocumentID, 'Job Marked as STAT',HistoryDateTime, jobtype, UserId, MRN, FirstName, MI, LastName,null, null, null  FROM Job_History
		WHERE JobNumber = @vvcrJobnumber and  STAT = 1 ORDER BY JobHistoryID DESC
 SELECT * FROM @TempJobsHostory1 ORDER BY IsError,SgId ASC

END

GO
