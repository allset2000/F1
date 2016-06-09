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
DECLARE @ScheduleID TABLE (ScheduleID BIGINT, AppointmentID VARCHAR(100), ResourceID VARCHAR(1000))
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

DECLARE @schedulesToAdd TABLE
	(ID INT, ClinicID smallint, AppointmentDate datetime, MRN varchar(36), AppointmentID varchar(100), EncounterID varchar(50), Attending varchar(50), LocationID varchar(50), LocationName varchar(100), ReasonID varchar(50), ReasonName varchar(200),
	ResourceID varchar(1000), ResourceName varchar(1000), Status smallint, AdditionalData varchar(max), ReferringID varchar(50), referringName varchar(100), attendingFirst varchar(120), attendingLast varchar(120), alternate_id varchar(36), type varchar(1), exactMatch bit, existing bit)

INSERT INTO @schedulesToAdd 		
	SELECT RI.ID, @clinicID, @AppointmentDate, @MRN, @appointmentID, @encounterID, @attending, @locationID, @LocationName, @ReasonID, @ReasonName, 
		RI.value, RN.value, @Status, @additionalData, @referringID, @ReferringName, @attendingFirst, @attendingLast, @alternate_id, @type, 0,0   
	FROM 
		(SELECT ROW_Number() OVER (ORDER BY (SELECT 1)) as ID, * FROM split(@ResourceID,'|')) RI
		INNER JOIN (SELECT ROW_Number() OVER (ORDER BY (SELECT 1)) as ID, * FROM split(@ResourceName,'|')) RN ON RI.ID=RN.ID

UPDATE @schedulesToAdd SET exactmatch = 
	CASE WHEN 		
		S.AppointmentDate = SA.AppointmentDate AND
		S.PatientID = @PatientID AND
		ISNULL (S.EHREncounterID, '') = ISNULL (SA.EncounterID, '') AND
		ISNULL (S.Attending, '') = ISNULL (SA.Attending, '') AND
		S.LocationID = SA.LocationID AND
		S.LocationName = SA.LocationName AND
		S.ReasonID = SA.ReasonID AND
		S.ReasonName = SA.ReasonName AND
		S.ResourceID = SA.ResourceID AND
		S.ResourceName = SA.ResourceName AND
		S.Status = SA.Status AND
		ISNULL (S.AdditionalData, '') = ISNULL (SA.AdditionalData, '') AND
		ISNULL (S.ReferringID, '') = ISNULL (SA.ReferringID, '') AND
		ISNULL (S.ReferringName, '') = ISNULL (SA.referringName, '') AND
		ISNULL (S.AttendingFirst, '') = ISNULL (SA.attendingFirst, '') AND
		ISNULL (S.AttendingLast, '') = ISNULL (SA.attendingLast, '')
	THEN 1 ELSE 0 END
	,existing = 
	CASE WHEN S.ResourceID = SA.ResourceID THEN 1 ELSE 0 END
	FROM Schedules S INNER JOIN @schedulesToAdd SA
	ON
		S.ClinicID = SA.ClinicID AND 
		S.AppointmentID = SA.AppointmentID
	WHERE 
		((SELECT count(*) FROM @schedulesToAdd)>1 AND (S.ResourceID = SA.ResourceID)) OR
		((SELECT count(*) FROM @schedulesToAdd)=1)


--Exits the Stored Procedure if the appointment data we have it exactly the same as whats already in the database
IF NOT EXISTS (SELECT * FROM @schedulesToAdd WHERE ISNULL(exactMatch,0) = 0)  
BEGIN
	print 'no new records' 
	RETURN 
END 

--Needs work, doesnt work when originally 2 appointemrns then down to 1.
--MARKS APPOINEMTNES AS DELETED WHEN THERE IS MORE THAN 1 APPOINTMENT AND THE RESOURCE IS MISSING IN THE UPDATE
IF (SELECT count(*) FROM @schedulesToAdd) > 1
BEGIN
	UPDATE Schedules SET Status=500, RowProcessed = 0 WHERE ClinicID = @ClinicID AND AppointmentID = @AppointmentID
	AND resourceID NOT IN (SELECT resourceID FROM @schedulesToAdd)
END

--IF AN APPOINTMENT IS NOT EXISTING ALREADY THEN INSERT THE APPOINTMENT
IF EXISTS (SELECT * FROM @schedulesToAdd WHERE ISNULL(existing,0) = 0)
BEGIN
	
	INSERT INTO Schedules 
		(ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID,
		 LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, referringID,
		 ReferringName, AttendingFirst, AttendingLast, Type, CreateDate, ChangedOn,UpdatedDateInUTC)
	OUTPUT Inserted.ScheduleID, Inserted.AppointmentID, Inserted.ResourceID INTO @ScheduleID	
	SELECT 
		ClinicID, AppointmentDate, @PatientID, AppointmentID, EncounterID, Attending, LocationID, 
		ISNULL(LocationName,''), ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ReferringID, 
		referringName, attendingFirst, attendingLast, type, GETDATE(), GETDATE(),GETUTCDATE()	
	FROM @schedulesToAdd WHERE existing = 0
	
END
ELSE
BEGIN
	
	UPDATE Schedules
	SET 
		AppointmentDate = SA.AppointmentDate, 
		PatientID = @PatientID,
		EHREncounterID = SA.EncounterID,
		Attending = SA.Attending,
		LocationID = SA.LocationID,
		LocationName = ISNULL(SA.LocationName,''),
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
	OUTPUT Inserted.ScheduleID, Inserted.AppointmentID, Inserted.ResourceID INTO @ScheduleID
	FROM Schedules S INNER JOIN @schedulesToAdd SA ON S.ClinicID = SA.ClinicID AND S.AppointmentID = SA.AppointmentID
	WHERE
		((SELECT count(*) FROM @schedulesToAdd)>1 AND (S.ResourceID = SA.ResourceID)) OR
		((SELECT count(*) FROM @schedulesToAdd)=1)
END

--INSERT INTO TRACKING TABLE
INSERT INTO SchedulesTracking 
		(ScheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EncounterID, Attending, LocationID, 
		 LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ChangedOn, ChangedBy, 
		 referringID, ReferringName, AttendingFirst, AttendingLast, Type)
SELECT S.ScheduleID, SA.ClinicID, SA.AppointmentDate, @PatientID, SA.AppointmentID, SA.EncounterID, SA.Attending, SA.LocationID,
	   ISNULL(SA.LocationName,''), SA.ReasonID, SA.ReasonName, SA.ResourceID, SA.ResourceName, SA.Status, SA.AdditionalData, GETDATE(), 'HL7',
		SA.referringID, SA.referringname, SA.AttendingFirst, SA.attendingLast, SA.Type
FROM @ScheduleID S INNER JOIN @schedulesToAdd SA ON S.appointmentID=SA.appointmentID AND S.resourceID=SA.resourceID


-- Ensure the RulesReasons and RulesProviders tables are updated
--EXEC dbo.ins_upd_rulesreasons @ClinicID, @ReasonID, @ReasonName, @Type
--EXEC dbo.ins_upd_rulesproviders @ClinicID, @ResourceID, @ResourceName


END
GO
