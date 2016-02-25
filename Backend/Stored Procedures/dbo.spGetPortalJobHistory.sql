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
*      25-FEB-2016 Narender: #731# Added STAT Field to insert into Job History 
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobHistory]  
(
 @vvcrJobnumber VARCHAR(20)        
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
	FirstName VARCHAR(50),
	 MI VARCHAR(50),
	 LastName VARCHAR(50),
	 ClinicID smallint,
	 SgId int,
	 IsError int -- To Identify the error existence in the job history page
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
 INSERT INTO @TempJobsHostory1  
 SELECT TOP 1 JobNumber,DocumentID, 'Job Marked as STAT',HistoryDateTime, jobtype, UserId, MRN, FirstName, MI, LastName,null, null, null  FROM Job_History
		WHERE JobNumber = @vvcrJobnumber and  STAT = 1 ORDER BY JobHistoryID DESC

 SELECT * FROM @TempJobsHostory1 order by IsError,SgId asc


END

GO
