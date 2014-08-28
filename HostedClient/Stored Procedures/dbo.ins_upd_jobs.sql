
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Michael Cardwell>
-- Create date: <7/25/2013>
-- Description:	<This stored proceudre is called from Mirth for all schedule id's marked as 0.  It is used to build all the jobs for the schedule.>
-- Current procedure does not support multiple dictations for single job.
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_jobs]
@schedule_id BIGINT,
@flagProcessPastAppts INT = 0

AS
BEGIN
DECLARE @clinicID SMALLINT

DECLARE @locationId VARCHAR(50)
DECLARE @attendingId VARCHAR(50)
DECLARE @reasonId varchar(50)
DECLARE @resourceID varchar(50)

DECLARE @patientID INT
DECLARE @appointmentDate DATETIME
DECLARE @appointmentDateIncreased INT = 0
DECLARE @additionalData VARCHAR(MAX)
DECLARE @referringID VARCHAR(50)
DECLARE @RefDocID BIGINT
DECLARE @status INT

DECLARE @rule_hold TABLE(row int identity(1,1),ruleid BIGINT, actionid BIGINT, Dictatorid int, QueueID int, jobtypeid int)
CREATE TABLE #result (RESULT varchar(250))

--GET SCHEDULING INFORMATION
SELECT @clinicID = ClinicID, @locationid = locationID, @attendingId = attending, @reasonId = ReasonID, @patientID = PatientID, @appointmentDate = AppointmentDate, @additionalData = AdditionalData, @referringID=ReferringID, @resourceID=resourceID,
@status = CASE WHEN Status IN ('100','200') THEN 100 ELSE 500 END 
FROM Schedules S
WHERE ScheduleID = @schedule_id

--PAST APPOINTMNET FILTERING
IF @flagProcessPastAppts = 0 AND cast(convert(char(11), @appointmentDate, 113) as datetime)<cast(convert(char(11), getdate(), 113) as datetime)
BEGIN
	INSERT INTO #result SELECT 'APPOINTMENT DATE IS PAST CURRENT DATE AND FLAG IS SET TO: '+CAST(@flagProcessPastAppts AS VARCHAR(1))
	GOTO FINALIZE_JOB;
END

--SET FLAG TO 1 IF APPOINTMENT DATE INCREASED BY 1 DAY OR MORE
SET @appointmentDateIncreased = 
	(SELECT CASE WHEN
	(SELECT TOP 1 cast(convert(char(11), AppointmentDate, 113) as datetime) from SchedulesTracking where ScheduleID = @schedule_id ORDER BY ChangedOn DESC) < cast(convert(char(11), @appointmentDate, 113) as datetime)
	THEN 1 ELSE 0 END)

SET @RefDocID = (SELECT referringID FROM ReferringPhysicians WHERE ClinicID = @clinicID and PhysicianID = @referringID)

--GET OWNERID
DECLARE @OwnerID int
SELECT @OwnerID = dictatorid from Dictators where ClinicID = @clinicID and EHRProviderID = @attendingId

--UPDATE JOBS_ROW FOR MISSING ENCOUNTER
UPDATE Jobs_ROW SET AckStatus = 100 FROM Jobs_ROW JR INNER JOIN Jobs J on JR.JobID=J.JobID
INNER JOIN Encounters E ON J.EncounterID=E.EncounterID
INNER JOIN Schedules S ON E.ScheduleID=S.ScheduleID
WHERE JR.AckStatus = 310 and isnull(S.EHREncounterID,'') <> '' AND S.ScheduleID = @schedule_id
	
--EXACT MATCH RULE
INSERT INTO @rule_hold 
SELECT R.RuleID, RJ.ActionID, RJ.DictatorID, RJ.QueueID, R.JobTypeID FROM Rules R
INNER JOIN RulesJobs RJ WITH(NOLOCK) on R.RuleID=RJ.RuleID 
INNER JOIN RulesLocationsxref RLX WITH(NOLOCK) on R.RuleID=RLX.RuleID
INNER JOIN RulesReasonsxref RRX WITH(NOLOCK) on R.RuleID=RRX.RuleID
INNER JOIN RulesLocations RL WITH(NOLOCK) on RLX.LocationID = RL.ID
INNER JOIN RulesReasons RR WITH(NOLOCK) on RRX.ReasonID=RR.ID
INNER JOIN RulesProviders RP WITH(NOLOCK) on RJ.ProviderID=RP.ID
WHERE RP.EHRcode = @resourceID and RL.EHRCode = @locationId and RR.EHRCode = @reasonId and R.ClinicID = @clinicID
AND Enabled = 1 AND @appointmentDate BETWEEN R.BeginDate AND R.Enddate

--SKIP IF THERE ARE NO RULES
IF (SELECT COUNT(*) FROM @rule_hold) < 1
GOTO NO_RULE;

--UPDATE INSERT ENCOUNTER
DECLARE @enc_hold TABLE (encounterid BIGINT)
DECLARE @encounterid BIGINT

UPDATE Encounters SET AppointmentDate = @appointmentDate, PatientID = @patientID 
OUTPUT inserted.EncounterID INTO @enc_hold
WHERE ScheduleID = @schedule_id
IF @@ROWCOUNT = 0 
	BEGIN	
		INSERT INTO Encounters (PatientID, ScheduleID, AppointmentDate)
		OUTPUT inserted.EncounterID INTO @enc_hold
		VALUES (@patientID, @schedule_id, @appointmentDate)
	END

SET @encounterid = (SELECT encounterid FROM @enc_hold)	

--UPDATE JOBS, GET CURRENT JOBS
DECLARE @current_jobs_hold TABLE (jobid BIGINT, ruleid BIGINT, Status INT, enableUpdate INT)
DECLARE @current_dictations_hold TABLE (dictationid BIGINT)

--GET CURRENT JOBS
INSERT INTO @current_jobs_hold(jobid, ruleid, status, enableUpdate)
SELECT Jobid, R.ruleid, Status, 
	CASE WHEN Status=500 AND (SELECT TOP 1 ChangedBy FROM Jobstracking where JOBID = J.jobid ORDER BY ChangeDate desc) = 'HL7' THEN 1
		 WHEN Status=500 AND @appointmentDateIncreased = 1 THEN 1
		 WHEN Status=100 THEN 1
		 ELSE 0 END
FROM @rule_hold R INNER JOIN Jobs J WITH(NOLOCK) ON ((J.RuleID=R.RuleID and J.RuleID IS NOT NULL) or (J.RuleID IS NULL)) 
	 AND J.EncounterID = @encounterid

--UPDATE CURRENT JOBS
UPDATE Jobs SET OwnerDictatorID = @OwnerID, Status = @status, AdditionalData = @additionalData, RuleID=R.ruleid, JobTypeID=R.jobtypeid
FROM @rule_hold R 
INNER JOIN Jobs J on ((J.RuleID=R.RuleID and J.RuleID IS NOT NULL) or (J.RuleID IS NULL)) AND J.EncounterID = @encounterid
INNER JOIN @current_jobs_hold JH ON J.JobID = JH.jobid
WHERE enableUpdate = 1

--UPDATE CURRENT DICTATIONS
UPDATE Dictations SET Status = @status, DictatorID=R.Dictatorid, QueueID=R.QueueID 
OUTPUT inserted.DictationID INTO @current_dictations_hold
FROM Dictations D INNER JOIN Jobs J on D.JobID=J.JobID INNER JOIN @rule_hold R on J.RuleID=R.ruleid
WHERE D.JobID IN (SELECT JobID FROM @current_jobs_hold WHERE enableUpdate=1 )
AND D.Status IN ('100','500')

--INSERT INTO TRACKING TABLES
INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) 
	SELECT Jobid, @status, GETDATE(), 'HL7' FROM @current_jobs_hold WHERE enableUpdate=1
INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy) 
	SELECT DictationID, @status, GETDATE(), 'HL7' FROM @current_dictations_hold

UPDATE Jobs_Referring SET ReferringID = @RefDocID WHERE JobID IN (SELECT JobID FROM @current_jobs_hold) AND @RefDocID IS NOT NULL

INSERT INTO #result 
	SELECT 'UPDATED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: ' + cast(@status as varchar(3)) + ' RULE: ' + cast(ruleid as varchar(100)) FROM @current_jobs_hold where enableUpdate=1

--REMOVE JOBS THAT NO LONGER HAVE A VALID RULE
DECLARE @removed_jobs_hold TABLE (jobid BIGINT, ruleid BIGINT)
DECLARE @removed_dictations_hold TABLE (dictationid BIGINT)


UPDATE Jobs SET Status = 500 
OUTPUT inserted.JobID, inserted.RuleID INTO @removed_jobs_hold
WHERE EncounterID = @encounterid AND RuleID NOT IN (SELECT RuleID FROM @rule_hold) AND Status = 100
UPDATE Dictations SET Status = 500 
OUTPUT inserted.DictationID INTO @removed_dictations_hold
WHERE JobID IN (SELECT JobID FROM JOBS WHERE Encounterid = @encounterID AND JOBID NOT IN (SELECT JOBID FROM @current_jobs_hold)) AND Status = 100
INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) SELECT Jobid, 500, GETDATE(), 'HL7' FROM @removed_jobs_hold
INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy) SELECT DictationID, 500, GETDATE(), 'HL7' FROM @removed_dictations_hold
INSERT INTO #result SELECT 'REMOVED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: 500' + ' RULE: ' + cast(ruleid as varchar(100)) FROM @removed_jobs_hold


--INSERT NEW JOBS IF THERE IS A RULE AND STATUS IS NOT 500
IF (SELECT COUNT(*) FROM @rule_hold R 
	LEFT JOIN @current_jobs_hold C ON R.ruleid=C.ruleid 
	Where C.ruleid IS NULL) > = 1 AND @status <> 500
BEGIN
	-- BUILD JOBNUMBER
	DECLARE @jobnumber varchar(20)
	SELECT @jobnumber = 
			CASE WHEN max(jobnumber) is null 
			THEN RIGHT(CONVERT(VARCHAR(10), GETDATE(), 101),2)+LEFT(CONVERT(VARCHAR(10), GETDATE(), 101),2)+SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 101),4,2) + '000000'
			ELSE max(jobnumber)
			END 
	FROM jobs WHERE LEFT(jobnumber,6) = RIGHT(CONVERT(VARCHAR(10), GETDATE(), 101),2)+LEFT(CONVERT(VARCHAR(10), GETDATE(), 101),2)+SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 101),4,2)
	
	
	DECLARE @jobid_hold TABLE (row int identity(1,1),Ruleid BIGINT,jobid BIGINT)
	
	--INSERT INTO JOBS
	INSERT INTO Jobs (JobNumber, ClinicID, EncounterID, JobTypeID, OwnerDictatorID, Status, Stat, Priority, RuleID, AdditionalData)
	OUTPUT Inserted.RuleID, Inserted.JobID INTO @jobid_hold
	SELECT cast(@jobnumber as BIGINT) + ROW, @clinicID, @encounterid, jobtypeid, @OwnerID, 100, 0, 0, ruleid, @additionalData 
	FROM @rule_hold 
	WHERE ruleid NOT IN (SELECT ruleid FROM @current_jobs_hold)
	ORDER BY ROW ASC
		
	--INSERT INTO JOBS TRACKING
	INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) SELECT Jobid, 100, GETDATE(), 'HL7' FROM @jobid_hold
	
	--INSERT INTO JOBS REFERRING
	INSERT INTO Jobs_Referring (JobID, ReferringID) SELECT Jobid, @RefDocID FROM @jobid_hold WHERE @RefDocID IS NOT NULL
	
	INSERT INTO #result SELECT 'INSERTED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: ' + cast(@status as varchar(3)) + ' RULE: ' + cast(rj.ruleid as varchar(100)) 
	FROM @rule_hold RJ INNER JOIN @jobid_hold JH on RJ.ruleid=JH.Ruleid and RJ.row=JH.row WHERE RJ.ruleid NOT IN (SELECT ruleid FROM @current_jobs_hold)
						
	--INSERT INTO DICTATIONS	
	DECLARE @dictationid_hold TABLE (Dictationid BIGINT)
	INSERT INTO Dictations (JobID, DictationTypeID, DictatorID, QueueID, Status, Duration, MachineName, FileName, ClientVersion)
	OUTPUT inserted.DictationID INTO @Dictationid_hold
	SELECT jobid, DT.DictationTypeID,Dictatorid, queueid, 100, 0, '', '', ''
	FROM @rule_hold RJ 
	INNER JOIN DictationTypes DT ON RJ.JobTypeID=DT.JobTypeID 
	INNER JOIN @jobid_hold JH ON RJ.ruleid=JH.Ruleid
	WHERE RJ.ruleid NOT IN (SELECT ruleid FROM @current_jobs_hold)
		
	INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy)
	SELECT DictationID, 100, GETDATE(), 'HL7' FROM @dictationid_hold
	
END
GOTO FINALIZE_JOB;

NO_RULE:
	INSERT INTO #result values ('NO RULE')
	DECLARE @job_id_delete TABLE (jobid BIGINT)

	INSERT INTO @job_id_delete 
	SELECT J.Jobid FROM Jobs J 
	INNER JOIN Encounters E ON J.Encounterid=E.encounterid 
	WHERE E.ScheduleID = @schedule_id

	UPDATE Jobs SET Status = 500
	FROM Jobs J INNER JOIN @job_id_delete JD ON J.JobID=JD.jobid
	WHERE Status IN ('100','500') 
	UPDATE Dictations SET Status = 500 
	FROM Dictations D INNER JOIN @job_id_delete JD ON D.JobID=JD.jobid
	WHERE Status IN ('100','500')
	RETURN
	
FINALIZE_JOB:
	SELECT result FROM #result
	RETURN	
END
GO
