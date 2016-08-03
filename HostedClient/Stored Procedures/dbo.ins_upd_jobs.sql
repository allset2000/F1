SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
-- =============================================
 
-- Author:      <Michael Cardwell>
 
-- Create date: <7/25/2013>
 
-- Description: <This stored proceudre is called from Mirth for all schedule id's marked as 0.  It is used to build all the jobs for the schedule.>
 
-- Current procedure does not support multiple dictations for single job.
 
-- =============================================
 --exec ins_upd_jobs 27908737,0
CREATE PROCEDURE [dbo].[ins_upd_jobs]
 
@schedule_id BIGINT, 
@flagProcessPastAppts INT = 0
 
 
 
 
AS
 
BEGIN
 

 set transaction isolation level read uncommitted

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
 
DECLARE @EncounterRowCount INT


   IF OBJECT_ID('tempdb..#TempJobBuilderLogs') IS NOT NULL
			DROP TABLE #TempJobBuilderLogs

 CREATE TABLE #TempJobBuilderLogs
		(ScheduleID BIGINT, StartTime DateTime,EndTime Datetime,Step1 INT,Step2 INT,Step3 INT,Step4 INT,Step5 INT,Step6 INT,Step7 INT,Step8 INT,
		 Step9 INT,Step10 INT,Step11 INT,Step12 INT,Step13 INT,Step14 INT,Step15 INT,Step16 INT,Step17 INT,Step18 INT,
		 Step19 INT,Step20 INT,Step21 INT,Step22 INT,Step23 INT,Step24 INT,Step25 INT,Step26 INT,Step27 INT,Step28 INT,
		 Step29 INT,Step30 INT,Step31 INT,Step32 INT,Step33 INT)
 
CREATE TABLE #rule_hold (row int identity(1,1),ruleid BIGINT, actionid BIGINT, Dictatorid int, QueueID int, jobtypeid int)
 
CREATE TABLE #result (RESULT varchar(250))
 
 declare @StartTime datetime = GetDate()
 declare @EndTime datetime
 
 
--GET SCHEDULING INFORMATION
 --set @EndTime = GetDate()
 INSERT INTO #TempJobBuilderLogs(ScheduleID, StartTime) SELECT  @schedule_id,GETDATE()
 set @StartTime = GetDate()

SELECT @clinicID = ClinicID, @locationid = locationID, @attendingId = attending, @reasonId = ReasonID, @patientID = PatientID, @appointmentDate = AppointmentDate, @additionalData = AdditionalData, @referringID=ReferringID, @resourceID=resourceID,
 
@status = CASE WHEN Status IN ('100','200') THEN 100 ELSE 500 END 
 
FROM Schedules S
 
WHERE ScheduleID = @schedule_id
 

 set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step1=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()

 
--PAST APPOINTMNET FILTERING
 
IF @flagProcessPastAppts = 0 AND cast(convert(char(11), @appointmentDate, 113) as datetime)<cast(convert(char(11), GetDate(), 113) as datetime)
 
BEGIN

set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step2=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()

 
    INSERT INTO #result SELECT 'APPOINTMENT DATE IS PAST CURRENT DATE AND FLAG IS SET TO: '+CAST(@flagProcessPastAppts AS VARCHAR(1))
 
    GOTO FINALIZE_JOB;
 
END
 
 
 set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step3=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()

 
--SET FLAG TO 1 IF APPOINTMENT DATE INCREASED BY 1 DAY OR MORE
 
SET @appointmentDateIncreased = 
 
    (SELECT CASE WHEN
 
    (SELECT TOP 1 cast(convert(char(11), AppointmentDate, 113) as datetime) from SchedulesTracking where ScheduleID = @schedule_id ORDER BY ChangedOn DESC) < cast(convert(char(11), @appointmentDate, 113) as datetime)
 
    THEN 1 ELSE 0 END)
 
 
 set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step4=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
  
SET @RefDocID = (SELECT referringID FROM ReferringPhysicians WHERE ClinicID = @clinicID and PhysicianID = @referringID)
 
 
 
set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step5=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
 
 
--GET OWNERID
 
DECLARE @OwnerID int
 
SELECT @OwnerID = dictatorid from Dictators where ClinicID = @clinicID and EHRProviderID = @attendingId
 
 set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step6=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
 
 
--UPDATE JOBS_ROW FOR MISSING ENCOUNTER
 
UPDATE Jobs_ROW SET AckStatus = 100 FROM Jobs_ROW JR INNER JOIN Jobs J on JR.JobID=J.JobID
 
INNER JOIN Encounters E ON J.EncounterID=E.EncounterID
 
INNER JOIN Schedules S ON E.ScheduleID=S.ScheduleID
 
WHERE JR.AckStatus = 310 and isnull(S.EHREncounterID,'') <> '' AND S.ScheduleID = @schedule_id
 
  set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step7=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
  
 
--EXACT MATCH RULE
 
INSERT INTO #rule_hold 
 
SELECT R.RuleID, RJ.ActionID, RJ.DictatorID, RJ.QueueID, R.JobTypeID FROM Rules R
 
INNER JOIN RulesJobs RJ WITH(NOLOCK) on R.RuleID=RJ.RuleID 
 
INNER JOIN RulesLocationsxref RLX WITH(NOLOCK) on R.RuleID=RLX.RuleID
 
INNER JOIN RulesReasonsxref RRX WITH(NOLOCK) on R.RuleID=RRX.RuleID
 
INNER JOIN RulesLocations RL WITH(NOLOCK) on RLX.LocationID = RL.ID
 
INNER JOIN RulesReasons RR WITH(NOLOCK) on RRX.ReasonID=RR.ID
 
INNER JOIN RulesProviders RP WITH(NOLOCK) on RJ.ProviderID=RP.ID
 
WHERE RP.EHRcode = @resourceID and RL.EHRCode = @locationId and RR.EHRCode = @reasonId and R.ClinicID = @clinicID
 
AND Enabled = 1 AND @appointmentDate BETWEEN R.BeginDate AND R.Enddate
 
 
 
 set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step8=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
 
--SKIP IF THERE ARE NO RULES
 
IF (SELECT COUNT(*) FROM #rule_hold) < 1
 
GOTO NO_RULE;
 
 
 
 
--UPDATE INSERT ENCOUNTER
 
CREATE TABLE #enc_hold (encounterid BIGINT)
 
DECLARE @encounterid BIGINT
 
 
  
UPDATE Encounters SET AppointmentDate = @appointmentDate, PatientID = @patientID,UpdatedDateInUTC=GETUTCDATE()
 
OUTPUT inserted.EncounterID INTO #enc_hold
 
WHERE ScheduleID = @schedule_id

SET @EncounterRowCount = @@ROWCOUNT

set @EndTime = GetDate()
	 UPDate #TempJobBuilderLogs SET Step9=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
	 
 set @StartTime = GetDate()
 
IF @EncounterRowCount = 0 
 
    BEGIN   

 
        INSERT INTO Encounters (PatientID, ScheduleID, AppointmentDate,UpdatedDateInUTC)
 
        OUTPUT inserted.EncounterID INTO #enc_hold
 
        VALUES (@patientID, @schedule_id, @appointmentDate,GETUTCDATE())

		SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step10=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
 
    END
 
 
 
 
SET @encounterid = (SELECT encounterid FROM #enc_hold)  
 
 
 
 
--UPDATE JOBS, GET CURRENT JOBS
 
CREATE TABLE #current_jobs_hold  (jobid BIGINT, ruleid BIGINT, Status INT, enableUpdate INT)
 
CREATE TABLE #current_dictations_hold (dictationid BIGINT)
 
 	SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step11=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
 
--GET CURRENT JOBS
 
INSERT INTO #current_jobs_hold(jobid, ruleid, status, enableUpdate)
 
SELECT Jobid, R.ruleid, Status, 
 
    CASE WHEN Status=500 AND (SELECT TOP 1 ChangedBy FROM Jobstracking where JOBID = J.jobid ORDER BY ChangeDate desc) = 'HL7' THEN 1
 
         WHEN Status=500 AND @appointmentDateIncreased = 1 THEN 1
 
         WHEN Status=100 THEN 1
 
         ELSE 0 END
 
FROM #rule_hold R INNER JOIN Jobs J WITH(NOLOCK) ON ((J.RuleID=R.RuleID and J.RuleID IS NOT NULL) or (J.RuleID IS NULL)) 
 
     AND J.EncounterID = @encounterid
 
 
 	SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step12=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
  
--UPDATE CURRENT JOBS
 
    UPDATE J 
 
    SET 
 
        J.OwnerDictatorID = @OwnerID, 
 
        J.Status = @status, 
 
        J.AdditionalData = @additionalData, 
 
        J.RuleID=R.ruleid, 
 
        J.JobTypeID=R.jobtypeid,
 
        J.UpdatedDateInUTC=GETUTCDATE()
 
    FROM Jobs J     
 
    INNER JOIN #current_jobs_hold JH ON J.JobID = JH.jobid
 
    INNER JOIN #rule_hold R on ((J.RuleID=R.RuleID and J.RuleID IS NOT NULL) or (J.RuleID IS NULL)) 
 
    WHERE enableUpdate = 1 AND J.EncounterID = @encounterid
 
 
      SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step13=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
  
 
--UPDATE CURRENT DICTATIONS
 
UPDATE Dictations SET Status = @status, DictatorID=R.Dictatorid, QueueID=R.QueueID,
 
        UpdatedDateInUTC=GETUTCDATE()
 
OUTPUT inserted.DictationID INTO #current_dictations_hold
 
FROM Dictations D INNER JOIN Jobs J on D.JobID=J.JobID INNER JOIN #rule_hold R on J.RuleID=R.ruleid
 
WHERE D.JobID IN (SELECT JobID FROM #current_jobs_hold WHERE enableUpdate=1 )
 
AND D.Status IN ('100','500')
 
 
 
   SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step14=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
--INSERT INTO TRACKING TABLES
 
INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) 
 
    SELECT Jobid, @status, GetDate(), 'HL7' FROM #current_jobs_hold WHERE enableUpdate=1
 
INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy) 
 
    SELECT DictationID, @status, GetDate(), 'HL7' FROM #current_dictations_hold
 
 
 
   SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step15=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
  
UPDATE Jobs_Referring SET ReferringID = @RefDocID WHERE JobID IN (SELECT JobID FROM #current_jobs_hold) AND @RefDocID IS NOT NULL
 
 
 
  SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step16=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
  
INSERT INTO #result 
 
    SELECT 'UPDATED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: ' + cast(@status as varchar(3)) + ' RULE: ' + cast(ruleid as varchar(100)) FROM #current_jobs_hold where enableUpdate=1
 
 
 
 
--REMOVE JOBS THAT NO LONGER HAVE A VALID RULE
 
CREATE TABLE #removed_jobs_hold (jobid BIGINT, ruleid BIGINT)
 
CREATE TABLE #removed_dictations_hold (dictationid BIGINT)
 
 
 
 
         SET @EndTime = GetDate()
		 UPDate #TempJobBuilderLogs SET Step17=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
		 
		SET @StartTime = GetDate()
  
 
 
UPDATE Jobs SET Status = 500,
 
        UpdatedDateInUTC=GETUTCDATE() 
 
OUTPUT inserted.JobID, inserted.RuleID INTO #removed_jobs_hold
 
WHERE EncounterID = @encounterid AND RuleID NOT IN (SELECT RuleID FROM #rule_hold) AND Status = 100
 
		SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step18=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  

UPDATE Dictations SET Status = 500 
 
OUTPUT inserted.DictationID INTO #removed_dictations_hold
 
WHERE JobID IN (SELECT JobID FROM JOBS WHERE Encounterid = @encounterID AND JOBID NOT IN (SELECT JOBID FROM #current_jobs_hold)) AND Status = 100
 
INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) SELECT Jobid, 500, GetDate(), 'HL7' FROM #removed_jobs_hold
 
INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy) SELECT DictationID, 500, GetDate(), 'HL7' FROM #removed_dictations_hold
 
INSERT INTO #result SELECT 'REMOVED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: 500' + ' RULE: ' + cast(ruleid as varchar(100)) FROM #removed_jobs_hold
 
 
 
 
 		SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step19=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
 
--INSERT NEW JOBS IF THERE IS A RULE AND STATUS IS NOT 500
 
IF (SELECT COUNT(*) FROM #rule_hold R 
 
    LEFT JOIN #current_jobs_hold C ON R.ruleid=C.ruleid 
 
    Where C.ruleid IS NULL) > = 1 AND @status <> 500
 
BEGIN
 
    -- BUILD JOBNUMBER
 
		SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step20=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    DECLARE @jobnumber varchar(20)
 
    SELECT @jobnumber = convert(varchar(10), GetDate(), 112) + Replace(convert(varchar(15), GetDate(), 114) ,':','')
 
 
    --        CASE WHEN max(jobnumber) is null 
 
    --        THEN RIGHT(CONVERT(VARCHAR(10), GetDate(), 101),2)+LEFT(CONVERT(VARCHAR(10), GetDate(), 101),2)+SUBSTRING(CONVERT(VARCHAR(10), GetDate(), 101),4,2) + '000000'
 
    --        ELSE max(jobnumber)
 
    --        END 
 
    --FROM jobs WHERE LEFT(jobnumber,6) = RIGHT(CONVERT(VARCHAR(10), GetDate(), 101),2)+LEFT(CONVERT(VARCHAR(10), GetDate(), 101),2)+SUBSTRING(CONVERT(VARCHAR(10), GetDate(), 101),4,2)
 
     
 
     
 
    CREATE TABLE #jobid_hold (row int identity(1,1),Ruleid BIGINT,jobid BIGINT)
 
     
	SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step21=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    --INSERT INTO JOBS
 
    INSERT INTO Jobs (JobNumber, ClinicID, EncounterID, JobTypeID, OwnerDictatorID, Status, Stat, Priority, RuleID, AdditionalData,UpdatedDateInUTC)
 
    OUTPUT Inserted.RuleID, Inserted.JobID INTO #jobid_hold
 
    SELECT cast(@jobnumber as BIGINT) + ROW, @clinicID, @encounterid, jobtypeid, @OwnerID, 100, 0, 0, ruleid, @additionalData,GETUTCDATE()
 
    FROM #rule_hold 
 
    WHERE ruleid NOT IN (SELECT ruleid FROM #current_jobs_hold)
 
    ORDER BY ROW ASC
 
         
	SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step22=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    --INSERT INTO JOBS TRACKING
 
    INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy) SELECT Jobid, 100, GetDate(), 'HL7' FROM #jobid_hold
 
     
	SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step23=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    --INSERT INTO JOBS REFERRING
 
    INSERT INTO Jobs_Referring (JobID, ReferringID) SELECT Jobid, @RefDocID FROM #jobid_hold WHERE @RefDocID IS NOT NULL
 
     
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step24=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
  
    INSERT INTO #result SELECT 'INSERTED JOB: ' + cast(jobid as varchar(100)) +  ' CLINICID: ' + cast(@clinicID as varchar(5)) + ' STATUS: ' + cast(@status as varchar(3)) + ' RULE: ' + cast(rj.ruleid as varchar(100)) 
 
    FROM #rule_hold RJ INNER JOIN #jobid_hold JH on RJ.ruleid=JH.Ruleid and RJ.row=JH.row WHERE RJ.ruleid NOT IN (SELECT ruleid FROM #current_jobs_hold)
 
                         
 
    --INSERT INTO DICTATIONS    
 
    CREATE TABLE #dictationid_hold (Dictationid BIGINT)
 
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step25=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    INSERT INTO Dictations (JobID, DictationTypeID, DictatorID, QueueID, Status, Duration, MachineName, FileName, ClientVersion,UpdatedDateInUTC)
 
    OUTPUT inserted.DictationID INTO #Dictationid_hold
 
    SELECT jobid, DT.DictationTypeID,Dictatorid, queueid, 100, 0, '', '', '',GETUTCDATE()
 
    FROM #rule_hold RJ 
 
    INNER JOIN DictationTypes DT ON RJ.JobTypeID=DT.JobTypeID 
 
    INNER JOIN #jobid_hold JH ON RJ.ruleid=JH.Ruleid
 
    WHERE RJ.ruleid NOT IN (SELECT ruleid FROM #current_jobs_hold)
 
         
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step26=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy)
 
    SELECT DictationID, 100, GetDate(), 'HL7' FROM #dictationid_hold
 
     
 
END
 
GOTO FINALIZE_JOB;
 
 
 
 
NO_RULE:
 
    INSERT INTO #result values ('NO RULE')
 
    CREATE TABLE #job_id_delete (jobid BIGINT)
 
 
 
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step27=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    INSERT INTO #job_id_delete 
 
    SELECT J.Jobid FROM Jobs J 
 
    INNER JOIN Encounters E ON J.Encounterid=E.encounterid 
 
    WHERE E.ScheduleID = @schedule_id
 
 
 
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step28=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
    UPDATE Jobs SET Status = 500,UpdatedDateInUTC=GETUTCDATE()
 
    FROM Jobs J INNER JOIN #job_id_delete JD ON J.JobID=JD.jobid
 
    WHERE Status IN ('100','500') 

	 
SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step29=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()
  
 
    UPDATE Dictations SET Status = 500 
 
    FROM Dictations D INNER JOIN #job_id_delete JD ON D.JobID=JD.jobid
 
    WHERE Status IN ('100','500')
 
  
       SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step30=DATEDIFF(MILLISECOND, @StartTime, @EndTime)
			
		SET @StartTime = GetDate()


		   UPDATE schedules set rowprocessed = 1 WHERE scheduleid =@schedule_id 

		  SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step31=DATEDIFF(MILLISECOND, @StartTime, @EndTime)			
		  SET @StartTime = GetDate()

		UPDate #TempJobBuilderLogs SET EndTime=GETDATE() 
		
		INSERT INTO AuditLogJobBuilder
		SELECT * FROM #TempJobBuilderLogs
       
    RETURN
 
     
 
FINALIZE_JOB:
 
    SELECT result FROM #result

	  SET @EndTime = GetDate()
		UPDate #TempJobBuilderLogs SET Step32=DATEDIFF(MILLISECOND, @StartTime, @EndTime)

			SET @StartTime = GetDate()
		   UPDATE schedules set rowprocessed = 1 WHERE scheduleid =@schedule_id 

		  SET @EndTime = GetDate()
			UPDate #TempJobBuilderLogs SET Step33=DATEDIFF(MILLISECOND, @StartTime, @EndTime)			
		  
	UPDate #TempJobBuilderLogs SET EndTime=GETDATE() 
		
		INSERT INTO AuditLogJobBuilder
		SELECT * FROM #TempJobBuilderLogs
    RETURN 

 
END
GO
