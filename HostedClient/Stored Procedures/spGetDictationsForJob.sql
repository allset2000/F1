/******************************    
** File:  spGetDictationsForJob.sql    
** Name:  spGetDictationsForJob    
** Desc:  Get the Dictations based on job id 
** Auth:  Suresh    
** Date:  18/May/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetDictationsForJob  
*******************************/
spEntradadropStoredProcedure 'spGetDictationsForJob'
GO
CREATE PROCEDURE [dbo].[spGetDictationsForJob]    
(        
 @vintJobID BIGINT
)         
AS        
BEGIN 
	SELECT d.DictationID,
		d.JobID,
		d.DictationTypeID,
		d.DictatorID,
		d.QueueID,
		d.Status,
		d.Duration,
		d.MachineName,
		d.FileName,
		d.ClientVersion,
		dt.Name as DictationTypeName
	FROM Dictations d
	INNER JOIN DictationTypes dt
	ON d.DictationTypeID = dt.DictationTypeID
	WHERE d.JobID=@vintJobID
END 
