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
	@vvcrMRN INT = NULL,
	@vvcrJobType VARCHAR(100) = NULL,
	@vsintCurrentStatus SMALLINT,
	@vintDocumentID INT=NULL,
	@vvcrUserId VARCHAR(48) = NULL
) AS 
	BEGIN 
		IF @vvcrUserId IS NULL OR  @vvcrUserId = ''
		BEGIN
			SELECT @vvcrUserId = LastEditedById FROM JobEditingSummary JE
			INNER JOIN Jobs J
			ON J.jobid=JE.jobid
			WHERE J.JobNumber =@vvcrJobNumber
		END

		INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime)
		VALUES(@vvcrJobNumber,@vvcrMRN,@vvcrJobType,@vsintCurrentStatus,@vintDocumentID,@vvcrUserId,GETDATE())
	END
GO


