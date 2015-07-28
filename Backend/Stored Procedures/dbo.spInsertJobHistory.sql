/******************************  
** File:  spInsertJobHistory.sql  
** Name:  spInsertJobHistory  
** Desc:  for track job history details 
** Auth:  Suresh  
** Date:  16/July/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spInsertJobHistory]
(
	@vvcrJobNumber VARCHAR(20),
	@vvcrPatientId VARCHAR(20) = NULL,
	@vvcrJobType VARCHAR(100) = NULL,
	@vsintCurrentStatus SMALLINT = NULL,
	@vintDocumentID INT,
	@vintUserId INT
) AS 
	BEGIN 
		INSERT INTO Job_History (JobNumber,PatientId,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime)
		VALUES(@vvcrJobNumber,@vvcrPatientId,@vvcrJobType,@vsintCurrentStatus,@vintDocumentID,@vintUserId,GETDATE())
	END
GO


