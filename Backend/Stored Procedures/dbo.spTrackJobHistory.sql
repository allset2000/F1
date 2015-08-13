/******************************  
** File:  spTrackJobHistory.sql    
** Name:  spTrackJobHistory    
** Desc:  Track document,Patient and jobtype changes into Job history table
** Auth:  Suresh    
** Date:  11/08/2015
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------ 
*******************************/
CREATE PROCEDURE [dbo].[spTrackJobHistory] 
(    
@vvcrJobNumber VARCHAR(20),
@vintStatus INT,
@vvcrUserName VARCHAR(48)=null,
@vintDocumentId INT = null,
@vvcrJobType VARCHAR(100)=null,
@vintMRN INT = null
)     
AS    
BEGIN 
	INSERT [dbo].[Job_History](JobNumber, CurrentStatus,DocumentID,JobType,MRN,UserId,HistoryDateTime)
	VALUES(@vvcrJobNumber,@vintStatus,@vintDocumentId,@vvcrJobType,@vintMRN,@vvcrUserName,getdate())
END 
GO


