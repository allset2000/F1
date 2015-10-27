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
DECLARE @TempJobsHostory1 TABLE(  
	JobNumber VARCHAR(20),
	DocumentID int,  
	StatusGroup varchar(255), 
	StatusDate datetime, 
	JobType varchar(100),
	UserId VARCHAR(48),
	MRN VARCHAR(48),
	FirstName VARCHAR(50),
	MI VARCHAR(50),
	LastName VARCHAR(50),
	ClinicID smallint,
	SgId int
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

 SELECT * FROM @TempJobsHostory1 order by SgId asc


END