/******************************    
** File:  spGetImagesForJob.sql    
** Name:  spGetImagesForJob    
** Desc:  Get the Images based on jos id 
** Auth:  Suresh    
** Date:  18/May/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetImagesForJob  
*******************************/
spEntradadropStoredProcedure 'spGetImagesForJob'
GO
CREATE PROCEDURE [dbo].[spGetImagesForJob]    
(        
 @vintJobID BIGINT
)         
AS        
BEGIN 
	SELECT ImagePath FROM JobImages WHERE JobID = @vintJobID
END 
