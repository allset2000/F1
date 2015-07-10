/******************************    
** File:  spGetjobstracking.sql    
** Name:  spGetjobstracking    
** Desc:  Get the Jobatracking details based on job id    
** Auth:  Suresh    
** Date:  18/May/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetDictationsForJob  
*******************************/
CREATE PROCEDURE [dbo].[spGetjobstracking]    
(        
 @vintJobID BIGINT,  
 @vintStatus SMALLINT    
)         
AS        
BEGIN     
  SELECT jobsTrackingID,JobID,Status,ChangeDate,ChangedBy   
  FROM jobstracking   
  WHERE JobID=@vintJobID AND Status=@vintStatus  
END     