/******************************  
** File:  spRevertJobStatusForSRE.sql    
** Name:  spRevertJobStatusForSRE    
** Desc:  Update job status from 350 to 300 when exception occurs during transcoding under SRE service  
** Auth:  Suresh    
** Date:  29/04/2015
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------ 
*******************************/
spEntradadropStoredProcedure 'spRevertJobStatusForSRE'
GO
CREATE PROCEDURE [dbo].[spRevertJobStatusForSRE]
(    
@vvcrJobNumber NVARCHAR(20)
)     
AS    
BEGIN 
	UPDATE jobs SET Status = 300 WHERE JobNumber =  @vvcrJobNumber AND Status=350
END 



