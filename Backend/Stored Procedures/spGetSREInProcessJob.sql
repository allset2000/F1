/******************************  
** File:  spGetSREInProcessJob.sql  
** Name:  spGetSREInProcessJob  
** Desc:  Get SRE InProcess Job i.e. process started with BBN
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetSREInProcessJob]   
(    
 @vvcrJobNumber VARCHAR(20),
 @vintSRETypeId INT,
 @vintProcessingStatus INT
)    
AS    
BEGIN   
	IF (@vintProcessingStatus = 0)
		BEGIN
		  SELECT jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.IsLockedForProcessing,    
		  js.path    
		  FROM  Jobs jb      
		  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID    
		  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID    
		  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber      
		  WHERE  js.Status = 130    
		  AND jb.IsLockedForProcessing = 1   
		  AND jb.jobnumber = @vvcrJobNumber    
		  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = @vintSRETypeId) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=@vintSRETypeId))    
		  ORDER BY JB.Stat desc, JB.ReceivedOn desc    
		END	
END
GO