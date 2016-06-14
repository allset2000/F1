
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/22/2015
-- Description: SP used to create a random job for a given clinic / dictator
-- Mike Cardwell 5/17/2016: Modified SP to only create jobs for dictation job types and to exclude creating jobs for generic patients.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateRandomJobForDictator]
(
	@ClinicId INT,
	@DictatorId INT
)
AS
BEGIN

		DECLARE @PatientId INT
		DECLARE @JobTypeId INT
		DECLARE @RefPhyId INT
		DECLARE @AppointmentDate DateTime
		DECLARE @Date Date
		DECLARE @Hour INT
		DECLARE @Min INT
		DECLARE @MinVal INT
		DECLARE @EncounterId INT
		DECLARE @JobId INT
		DECLARE @QueueId INT
		DECLARE @DictationTypeId INT
		DECLARE @UTCDatewOffset DATETIME

		SET @UTCDatewOffset = DATEADD(MINUTE,+5,GETUTCDATE())

		-- Get Random Patient,JobType,RefPhy from clinic, choose random appointment time
		SET @PatientId = (SELECT TOP 1 PatientId FROM Patients WHERE ClinicId = @ClinicId AND Firstname <> 'GENERIC' ORDER BY NEWID())
		SET @JobTypeId = (SELECT TOP 1 JobTypeId FROM JobTypes WHERE ClinicId = @ClinicId AND JobtypeCategoryID = 1 ORDER BY NEWID())
		SET @RefPhyId = (SELECT TOP 1 ReferringId FROM ReferringPhysicians WHERE ClinicId = @ClinicId ORDER BY NEWID())
		SET @Date = GETDATE()
		SET @Hour = RAND() * 8 + 8 -- Random hour between the hours of 8am and 5pm
		SET @MinVal = RAND() * 3 + 1 -- Random minute value to choose from
		IF (@MinVal = 1) BEGIN SET @Min = 15 END ELSE IF (@MinVal = 2) BEGIN SET @Min = 30 END ELSE IF (@MinVal = 3) BEGIN SET @Min = 45 END
		SET @AppointmentDate = @Date
		SET @AppointmentDate = DATEADD(Hour,@Hour,@AppointmentDate)
		SET @AppointmentDate = DATEADD(Minute,@Min,@AppointmentDate)
		SET @QueueId = (SELECT DefaultQueueId FROM Dictators WHERE DictatorId = @DictatorId)
		SET @DictationTypeId = (SELECT DictationTypeId FROM DictationTypes WHERE ClinicId = @ClinicId and JobTypeId = @JobTypeId)

	   --Bug 9392 fixed--> If No DictationTypeID for JobtypeID avoid job creation
		IF(@DictationTypeId IS NULL)
		  RETURN

		-- Generate New JobNumber
		DECLARE @str varchar(10)
		DECLARE @val varchar(8)
		DECLARE @MaxVal INT
		DECLARE @NewJobNumber varchar(12)
		SET @str = (SELECT CONVERT(VARCHAR(10), GETDATE(), 112))
		SET @val = (SELECT SUBSTRING(@str,3,8))
		SET @MaxVal = (SELECT ISNULL (MAX (SUBSTRING (JobNumber, 7, 6)), 0) FROM Jobs WHERE SUBSTRING (JobNumber, 1, 6) = @val AND SUBSTRING (JobNumber, 13, 1) <> 'L') + 1
		SET @NewJobNumber = @val + REPLICATE('0',6 - LEN(@MaxVal)) + CAST(@MaxVal as VARCHAR)

		-- Create Encounter
		INSERT INTO Encounters(AppointmentDate,PatientId,ScheduleId,UpdatedDateInUTC) 
		VALUES(@AppointmentDate,@PatientId,NULL,@UTCDatewOffset)
		SET @EncounterId = (SELECT TOP 1 EncounterId FROM Encounters WHERE PatientId = @PatientId and AppointmentDate = @AppointmentDate ORDER BY EncounterId DESC)
		-- Create Job
		INSERT INTO Jobs(JobNumber,ClinicId,EncounterId,JobTypeId,OwnerDictatorId,Status,Stat,Priority,RuleId,AdditionalData,UpdatedDateInUTC)
		VALUES(@NewJobNumber,@ClinicId,@EncounterId,@JobTypeId,@DictatorId,100,0,0,0,NULL,@UTCDatewOffset)
		SET @JobId = (SELECT JobId FROM Jobs WHERE JobNumber = @NewJobNumber)
		-- Create Dictation
		INSERT INTO Dictations(JobId,DictationTypeId,DictatorId,QueueId,Status,Duration,MachineName,FileName,ClientVersion,UpdatedDateInUTC)
		VALUES(@JobId,@DictationTypeId,@DictatorId,@QueueId,100,0,'','','',@UTCDatewOffset)
END
GO
