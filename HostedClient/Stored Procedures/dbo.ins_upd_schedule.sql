SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- History
-- Ticket#	Date			Fixed by			Comments
-- #6077#	10 Feb 2016		Sharif Shaik		if @PatientID is NULL, EXIT the stored procedure without adding the record to schedules table
--			05 MAY 2016		Mike Cardwell		Redesigned SP to increase performance and reduce Duplicate code	
--			22 July 2016    Mike Cardwell		Resolved issue with duplicate appointmetns being created for Nextgen EHR's
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_schedule]
	@ClinicID smallint ,
	@AppointmentDate datetime,
	@MRN varchar(36),
	@AppointmentID varchar(100),
	@EncounterID varchar(50),
	@Attending varchar(50),
	@LocationID varchar(50),
	@LocationName varchar(100),
	@ReasonID varchar(50),
	@ReasonName varchar(200),
	@ResourceID varchar(1000),
	@ResourceName varchar(1000),
	@Status smallint,
	@AdditionalData varchar(max),
	@ReferringID varchar(50),
	@referringName varchar(100),
	@attendingFirst varchar(120),
	@attendingLast varchar(120),
	@alternate_id varchar(36) = NULL,
	@type varchar(1) = 'S'

AS
BEGIN

DECLARE @PatientID INT
DECLARE @orig_enc_id VARCHAR(50)
CREATE Table #ScheduleID  (ScheduleID BIGINT, AppointmentID VARCHAR(100), ResourceID VARCHAR(1000))
DECLARE @CurrentStatus INT

-- Find the PatientID
IF ISNULL (@MRN, '') <> ''
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND MRN = @MRN
ELSE
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND AlternateID = @alternate_id

-- #6077# - if @PatientID is NULL, EXIT the stored procedure without adding the record to schedules table
IF @PatientID IS NULL
BEGIN   
    RETURN
END

-- Preserve any existing EHREncounterID (subsequent messages may not have it)
SELECT @orig_enc_id = EHREncounterID, @currentStatus=Status FROM Schedules WHERE ClinicID = @ClinicID and AppointmentID = @AppointmentID

IF ISNULL (@orig_enc_id, '') <> ''
BEGIN
	SET @EncounterID = @orig_enc_id
END

IF ISNULL(@currentStatus,100) = 200 AND @Status = 100
BEGIN
	SET @status = 200
END

IF ISNULL(@additionalData,'')=''
BEGIN
	SET @additionalData = '<custom1>'+ dbo.fn_XMLEncode(isnull(@encounterID,'')) + '</custom1><custom2>'+ dbo.fn_XMLEncode(isnull(@AppointmentID,'')) + '</custom2><custom5>'+ dbo.fn_XMLEncode(isnull(@locationName,'')) + '</custom5><custom6>' + dbo.fn_XMLEncode(isnull(@LocationID,'')) + '</custom6><custom10>' + dbo.fn_XMLEncode(isnull(@ReferringID,'')) + '</custom10><custom11>' + dbo.fn_XMLEncode(isnull(@referringName,'')) +'</custom11>'
END

-- If the EHR isn't providing us the attending first/last name, pull it from the Dictators table
IF @attendingFirst = 'xref'
BEGIN
	-- Make sure we don't leave 'xref' if we can't find the dictator
	SELECT @attendingFirst = NULL
	SELECT @attendingLast = NULL
	SELECT @attendingFirst = FirstName, @attendingLast = LastName FROM Dictators WHERE EHRProviderID = @Attending AND ClinicID = @ClinicID
END

--CREATE TEMPORARY TABLES TO STAGE THE SCHEDULING DATA
IF OBJECT_ID('tempdb..#tempSchedules') IS NOT NULL
    DROP TABLE #tempSchedules

IF OBJECT_ID('tempdb..#schedulesToAdd') IS NOT NULL
    DROP TABLE #schedulesToAdd

CREATE TABLE #tempSchedules 
	(ScheduleID BIGINT, ClinicID smallint, AppointmentDate datetime, PatientID BIGINT, AppointmentID varchar(100), EHREncounterID varchar(50), Attending varchar(50), LocationID varchar(50), LocationName varchar(100), ReasonID varchar(50), ReasonName varchar(200),
	ResourceID varchar(1000), ResourceName varchar(1000), Status smallint, AdditionalData varchar(max), ReferringID varchar(50), referringName varchar(100), attendingFirst varchar(120), attendingLast varchar(120), type varchar(1))

CREATE TABLE #schedulesToAdd
	(ID INT, ClinicID smallint, AppointmentDate datetime, PatientID BIGINT, AppointmentID varchar(100), EHREncounterID varchar(50), Attending varchar(50), LocationID varchar(50), LocationName varchar(100), ReasonID varchar(50), ReasonName varchar(200),
	ResourceID varchar(1000), ResourceName varchar(1000), Status smallint, AdditionalData varchar(max), ReferringID varchar(50), referringName varchar(100), attendingFirst varchar(120), attendingLast varchar(120), type varchar(1), exactMatch bit, existing BIT)

--POPULATE TEMPORARY TABLES
INSERT INTO #tempSchedules
	SELECT DISTINCT scheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID, 
		ISNULL(LocationName,''), ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ReferringID, referringName, attendingFirst, attendingLast, type
	FROM Schedules 
	WHERE ClinicID = @clinicID AND appointmentID=@appointmentID

INSERT INTO #schedulesToAdd 		
	SELECT RI.ID, @clinicID, @AppointmentDate, @patientID, @appointmentID, @encounterID, @attending, @locationID, @LocationName, @ReasonID, @ReasonName, 
		RI.value, RN.value, @Status, @additionalData, @referringID, @ReferringName, @attendingFirst, @attendingLast, @type, 0,0 
	FROM 
		(SELECT ROW_Number() OVER (ORDER BY (SELECT 1)) as ID, * FROM split(@ResourceID,'|')) RI
		INNER JOIN (SELECT ROW_Number() OVER (ORDER BY (SELECT 1)) as ID, * FROM split(@ResourceName,'|')) RN ON RI.ID=RN.ID

DECLARE @scheduleCount INT
SET @scheduleCount = (SELECT COUNT(*) FROM #schedulesToAdd )

DECLARE @TEMPscheduleCount INT
SET @TEMPscheduleCount = (SELECT COUNT(*) FROM #tempSchedules  )

--FLAG IF INCOMING DATA IS AN EXACT MATCH OF CURRENT DATA
UPDATE #schedulesToAdd SET exactmatch = 1
	FROM #tempSchedules SA
	WHERE
		[#schedulesToAdd].AppointmentID = SA.AppointmentID AND	
		[#schedulesToAdd].AppointmentDate = SA.AppointmentDate AND
		[#schedulesToAdd].PatientID = SA.PatientID AND
		[#schedulesToAdd].EHREncounterID = SA.EHREncounterID AND
		[#schedulesToAdd].Attending = SA.Attending AND
		[#schedulesToAdd].LocationID = SA.LocationID AND
		[#schedulesToAdd].LocationName = SA.LocationName AND
		[#schedulesToAdd].ReasonID = SA.ReasonID AND
		[#schedulesToAdd].ReasonName = SA.ReasonName AND
		[#schedulesToAdd].ResourceID = SA.ResourceID AND
		[#schedulesToAdd].ResourceName = SA.ResourceName AND
		[#schedulesToAdd].Status = SA.Status AND
		[#schedulesToAdd].AdditionalData = SA.AdditionalData AND
		[#schedulesToAdd].ReferringID = SA.ReferringID AND
		[#schedulesToAdd].ReferringName = SA.referringName AND
		[#schedulesToAdd].AttendingFirst = SA.attendingFirst AND
		[#schedulesToAdd].AttendingLast = SA.attendingLast 

--FLAG IF INCOMING DATA ALREADY EXISTS 	
DECLARE @SQL NVARCHAR(MAX)
DECLARE @SQlfilter NVARCHAR(MAX)=''

	SET @SQL  = 'UPDATE #schedulesToAdd SET existing = 1
	FROM #tempSchedules SA
	WHERE
		[#schedulesToAdd].AppointmentID = SA.AppointmentID'
		IF @scheduleCount > 1 OR @TEMPscheduleCount > 1
		SET @SQLfilter = ' AND [#schedulesToAdd].resourceID=SA.resourceID'

	execute ( @sql+@SQLfilter )

--EXIT SP IF ALL INCOMGING DATA MATCHES EXACTLY WHATS ALREADY IN THE SYSTEM
IF NOT EXISTS (SELECT * FROM #schedulesToAdd WHERE ISNULL(exactMatch,0) = 0) AND @scheduleCount=((SELECT COUNT(*) FROM #tempSchedules WHERE STATUS <> 500 ))
BEGIN
	print 'no new records' 
	RETURN 
END 

--MARKS APPOINEMTNES AS DELETED WHEN THERE IS MORE THAN 1 APPOINTMENT AND THE RESOURCE IS MISSING IN THE UPDATE
IF (SELECT count(*) FROM #tempSchedules) > 1
BEGIN

	INSERT INTO #schedulesToAdd
	SELECT SCHEDULEid, ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID, 
		ISNULL(LocationName,''), ReasonID, ReasonName, ResourceID, ResourceName, '500', AdditionalData, ReferringID, referringName, attendingFirst, attendingLast, type,0,1
	FROM 
		#tempSchedules SA WHERE resourceID NOT IN (SELECT resourceID FROM #schedulesToAdd WITH(NOLOCK))
END

--IF AN APPOINTMENT IS NOT EXISTING ALREADY THEN INSERT THE APPOINTMENT
IF EXISTS (SELECT * FROM #schedulesToAdd WHERE ISNULL(existing,0) = 0)
BEGIN	
	
	INSERT INTO Schedules 
		(ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID,
		 LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, referringID,
		 ReferringName, AttendingFirst, AttendingLast, Type, CreateDate, ChangedOn,UpdatedDateInUTC)
	OUTPUT Inserted.ScheduleID, Inserted.AppointmentID, Inserted.ResourceID INTO #ScheduleID	
	SELECT 
		ClinicID, AppointmentDate, @PatientID, AppointmentID, EHREncounterID, Attending, LocationID, 
		ISNULL(LocationName,''), ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ReferringID, 
		referringName, attendingFirst, attendingLast, type, GETDATE(), GETDATE(),GETUTCDATE()	
	FROM #schedulesToAdd WHERE existing = 0 and Exactmatch = 0
	
END

IF EXISTS (SELECT * FROM #schedulesToAdd WHERE ISNULL(existing,0) > 0)
BEGIN

	SET @scheduleCount = (SELECT COUNT(*) FROM #schedulesToAdd )

	DECLARE @SQL2 NVARCHAR(MAX)
	DECLARE @SQlfilter2 NVARCHAR(MAX)=''

	SET @SQL2  = 'UPDATE Schedules
		SET 
			AppointmentDate = SA.AppointmentDate, 
			PatientID = SA.PatientID,
			EHREncounterID = SA.EHREncounterID,
			Attending = SA.Attending,
			LocationID = SA.LocationID,
			LocationName = ISNULL(SA.LocationName,'+''''''+'),
			ReasonID = SA.ReasonID,
			ReasonName = SA.ReasonName,
			ResourceID = SA.ResourceID,
			ResourceName = SA.ResourceName,
			Status = SA.Status,
			AdditionalData = SA.AdditionalData,
			ReferringID = SA.ReferringID,
			ReferringName = SA.referringName,
			AttendingFirst = SA.attendingFirst,
			AttendingLast = SA.attendingLast,
			RowProcessed = 0,
			Type = SA.Type,
			ChangedOn = GETDATE(),
			UpdatedDateInUTC=GETUTCDATE()
		OUTPUT Inserted.ScheduleID, Inserted.AppointmentID, Inserted.ResourceID INTO #ScheduleID
		FROM Schedules S 
		INNER JOIN #schedulesToAdd SA ON S.ClinicID = SA.ClinicID AND S.AppointmentID = SA.AppointmentID '
		IF @scheduleCount > 1
		SET @SQLfilter2 = ' AND S.resourceID=SA.resourceID'

	execute ( @sql2+@SQLfilter2 )

END

--INSERT INTO TRACKING TABLE
INSERT INTO SchedulesTracking 
		(ScheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EncounterID, Attending, LocationID, 
		 LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ChangedOn, ChangedBy, 
		 referringID, ReferringName, AttendingFirst, AttendingLast, Type)
SELECT S.ScheduleID, SA.ClinicID, SA.AppointmentDate, @PatientID, SA.AppointmentID, SA.EHREncounterID, SA.Attending, SA.LocationID,
	   ISNULL(SA.LocationName,''), SA.ReasonID, SA.ReasonName, SA.ResourceID, SA.ResourceName, SA.Status, SA.AdditionalData, GETDATE(), 'HL7',
		SA.referringID, SA.referringname, SA.AttendingFirst, SA.attendingLast, SA.Type
FROM #ScheduleID S WITH(NOLOCK) INNER JOIN #schedulesToAdd SA ON S.appointmentID=SA.appointmentID AND S.resourceID=SA.resourceID


-- Ensure the RulesReasons and RulesProviders tables are updated
--EXEC dbo.ins_upd_rulesreasons @ClinicID, @ReasonID, @ReasonName, @Type
--EXEC dbo.ins_upd_rulesproviders @ClinicID, @ResourceID, @ResourceName


END
GO
