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
	SELECT JH.JobNumber,JH.DocumentId,JG.StatusGroup,MAX(JH.HistoryDateTime) StatusDate,JH.JobType,JH.UserId,JH.MRN,JP.FirstName,JP.MI,JP.LastName
		FROM dbo.job_history JH  
		INNER JOIN dbo.StatusCodes SC ON JH.CurrentStatus= SC.StatusID
		INNER JOIN dbo.JobStatusGroup JG ON JG.Id = SC.StatusGroupId
		LEFT OUTER JOIN [dbo].[Jobs_Patients] JP
		ON cast(JH.MRN AS VARCHAR)  = jp.MRN and  JH.jobnumber = jp.jobnumber 
		WHERE JH.JobNumber=@vvcrJobnumber  
		GROUP BY jg.Id,JH.JobNumber,JG.StatusGroup,JH.JobType,JH.UserId,JH.DocumentId,JH.MRN,JP.FirstName,JP.MI,JP.LastName
		ORDER BY jg.id ASC
END   

