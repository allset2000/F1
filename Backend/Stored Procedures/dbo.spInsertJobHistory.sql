
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
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
** 1    25-FEB-2016 Narender: #731# Added STAT Field to insert into Job History
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
	@vvcrDOB VARCHAR(50) = NULL,
	@vbitStat BIT = NULL,
	@vsdtAppointmentDate SMALLDATETIME = NULL
) AS 
	BEGIN 
	DECLARE @oldStatus INT
	DECLARE @IsHistory BIT 
	DECLARE @newSTAT BIT 
	DECLARE @newMRN VARCHAR(50)
	DECLARE @newJobType VARCHAR(100)

	SET @newMRN = @vvcrMRN
	SET @newJobType = @vvcrJobType
	SET @IsHistory =0
	
		IF @vvcrUserId IS NULL OR  @vvcrUserId = ''
		BEGIN
			SELECT @vvcrUserId = LastEditedById FROM JobEditingSummary JE
			INNER JOIN Jobs J
			ON J.jobid=JE.jobid
			WHERE J.JobNumber =@vvcrJobNumber
		END
		
			
		-- if any AppointmentDateTime value is changed then track that previous value.
		SELECT  @vsdtAppointmentDate = CASE WHEN  AppointmentDate + AppointmentTime <> @vsdtAppointmentDate THEN AppointmentDate + AppointmentTime ELSE NULL END  FROM jobs WHERE JobNumber = @vvcrJobNumber	

		-- if any jobtype value is changed then track that previous value.
		SELECT  @vvcrJobType = CASE WHEN JobType <> @vvcrJobType THEN JobType ELSE NULL END  FROM jobs WHERE JobNumber = @vvcrJobNumber	
		
		-- if any STAT value is changed then track that previous value.
		SELECT  @newSTAT = CASE WHEN Stat = 1 and @vbitStat =1 THEN Stat ELSE NULL END  FROM jobs WHERE JobNumber = @vvcrJobNumber	
		
		-- if any domographics value is changed then track that previous value. 
		SELECT @vvcrMRN = CASE WHEN MRN <> @vvcrMRN THEN MRN ELSE NULL END,
		@vvcrFirstName = CASE WHEN FirstName <> @vvcrFirstName THEN FirstName ELSE NULL END,
		@vvcrMI = CASE WHEN MI <> @vvcrMI THEN MI ELSE NULL END,
		@vvcrLastName = CASE WHEN LastName <> @vvcrLastName THEN LastName ELSE NULL END,
		@vvcrDOB = CASE WHEN DOB <> @vvcrDOB THEN DOB ELSE NULL END
		FROM jobs_patients
		WHERE JOBNUMBER = @vvcrJobNumber

		if @vvcrMRN is null 
			BEGIN 
			SELECT @vvcrMRN =  MRN, @vvcrFirstName = FirstName,	@vvcrMI = MI,@vvcrLastName = LastName,@vvcrDOB =  DOB 
			FROM jobs_patients WHERE JOBNUMBER = @vvcrJobNumber
			SET @IsHistory =1
			END
		if @vvcrJobType is null 
			BEGIN
			SELECT @vvcrJobType=JobType FROM jobs WHERE JobNumber = @vvcrJobNumber	
			SET @IsHistory =1
			END

		-- if job is sent to finsh in Editor stage then we need to track in process data and status
		IF @vsintCurrentStatus >= 250 and not exists(SELECT 1 FROM JOB_HISTORY WHERE jobnumber=@vvcrJobNumber)
			BEGIN
				INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime,IsHistory)
				VALUES(@vvcrJobNumber,@vvcrMRN,@vvcrJobType,170,@vintDocumentID,@vvcrUserId,GETDATE(),@IsHistory)
			END

		-- For tracking the MRN and Jobtype history we need previous status
		SELECT @oldStatus = STATUS FROM JobStatusA WHERE jobnumber=@vvcrJobNumber
		IF(@oldStatus is NULL )
			SELECT @oldStatus = STATUS FROM JobStatusB WHERE jobnumber=@vvcrJobNumber
		
		IF @vsintCurrentStatus is null or @oldStatus <> @vsintCurrentStatus 
			SET @vsintCurrentStatus =@oldStatus
		
		IF @vsintCurrentStatus = 250
			SET	@vvcrUserId = NULL
						
		IF @vsintCurrentStatus = 260
		BEGIN
			SET @vvcrMRN = @newMRN
			SET @vvcrJobType = @newJobType
		END

		INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime,FirstName,MI,LastName,DOB,IsHistory,STAT,AppointmentDate)
		VALUES(@vvcrJobNumber,@vvcrMRN,@vvcrJobType,@vsintCurrentStatus,@vintDocumentID,@vvcrUserId,GETDATE(),@vvcrFirstName,@vvcrMI,@vvcrLastName,@vvcrDOB,@IsHistory,@newSTAT,@vsdtAppointmentDate)
	END
	
GO
