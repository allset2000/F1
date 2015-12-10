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
	@vvcrMRN VARCHAR(50) = NULL,
	@vvcrJobType VARCHAR(100) = NULL,
	@vsintCurrentStatus SMALLINT=NULL,
	@vintDocumentID INT=NULL,
	@vvcrUserId VARCHAR(48) = NULL,
	@vvcrFirstName VARCHAR(50) = NULL,
	@vvcrMI VARCHAR(50) = NULL,
	@vvcrLastName VARCHAR(50) = NULL,
	@vvcrDOB VARCHAR(50) = NULL
) AS 
	BEGIN 
	DECLARE @oldStatus INT

		IF @vvcrUserId IS NULL OR  @vvcrUserId = ''
		BEGIN
			SELECT @vvcrUserId = LastEditedById FROM JobEditingSummary JE
			INNER JOIN Jobs J
			ON J.jobid=JE.jobid
			WHERE J.JobNumber =@vvcrJobNumber
		END

		SELECT @vvcrMRN=MRN FROM Jobs_Patients WHERE jobnumber=@vvcrJobNumber
		SELECT @vvcrJobType=JobType FROM jobs WHERE JobNumber = @vvcrJobNumber	
	
		-- if job is sent to finsh in Editor stage then we need to track in process data and status
		IF @vsintCurrentStatus=270 and not exists(SELECT 1 FROM JOB_HISTORY WHERE jobnumber=@vvcrJobNumber)
			BEGIN
				INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime)
				VALUES(@vvcrJobNumber,@vvcrMRN,@vvcrJobType,170,@vintDocumentID,@vvcrUserId,GETDATE())
			END


		-- For tracking the MRN and Jobtype history we need previous status
		SELECT @oldStatus = STATUS FROM JobStatusA WHERE jobnumber=@vvcrJobNumber
		IF(@oldStatus is NULL )
			SELECT @oldStatus = STATUS FROM JobStatusB WHERE jobnumber=@vvcrJobNumber
		
		IF @vsintCurrentStatus is null or @oldStatus <> @vsintCurrentStatus 
			SET @vsintCurrentStatus =@oldStatus
	
	-- if domographics is change then track that details also
	IF EXISTS(SELECT 1 FROM [Jobs_Patients] WHERE [MRN] = @vvcrMRN AND [FirstName] = @vvcrFirstName AND [MI] = @vvcrMI AND [LastName] = @vvcrLastName AND [DOB] = @vvcrDOB AND [JobNumber] = @vvcrJobNumber)
		BEGIN
			SET @vvcrMRN = NULL
			SET @vvcrFirstName =NULL
			SET @vvcrMI =NULL
			SET @vvcrLastName=NULL
			SET @vvcrDOB = NULL
		END

		INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime,FirstName,MI,LastName,DOB)
		VALUES(@vvcrJobNumber,@vvcrMRN,@vvcrJobType,@vsintCurrentStatus,@vintDocumentID,@vvcrUserId,GETDATE(),@vvcrFirstName,@vvcrMI,@vvcrLastName,@vvcrDOB)
	END
GO

