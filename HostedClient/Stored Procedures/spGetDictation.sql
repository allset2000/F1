/******************************    
** File:  spGetDictation.sql    
** Name:  spGetDictation    
** Desc:  Get the Dictations based on dictation id 
** Auth:  Suresh    
** Date:  18/May/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetDictation  
*******************************/
spEntradadropStoredProcedure 'spGetDictation'
GO
CREATE PROCEDURE [dbo].[spGetDictation]    
(        
 @vintDictationID BIGINT
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
	WHERE d.DictationID=@vintDictationID
END 
