/******************************  
** File:  spUpdateHostedJobStatus.sql    
** Name:  spUpdateHostedJobStatus    
** Desc:  Update job status from 350 to 300 when exception occurs during transcoding under SRE service  
** Auth:  Suresh    
** Date:  29/04/2015
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------ 
*******************************/

CREATE PROCEDURE [dbo].[spUpdateHostedJobStatus]
(    
@vvcrJobNumber NVARCHAR(20)
)     
AS    
BEGIN 
  DECLARE @status smallint 
  SELECT @status=Status FROM jobs WHERE JobNumber =  @vvcrJobNumber   
  If(@status = 350)
	UPDATE jobs SET Status = 300 WHERE JobNumber =  @vvcrJobNumber
END 



