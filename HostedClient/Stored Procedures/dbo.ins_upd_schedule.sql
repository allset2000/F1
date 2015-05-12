
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
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
	@ResourceID varchar(50),
	@ResourceName varchar(100),
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
DECLARE @ScheduleID TABLE (ScheduleID BIGINT)
DECLARE @CurrentStatus INT

-- Find the PatientID
IF ISNULL (@MRN, '') <> ''
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND MRN = @MRN
ELSE
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND AlternateID = @alternate_id

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

-- If the EHR isn't providing us the attending first/last name, pull it from the Dictators table
IF @attendingFirst = 'xref'
BEGIN
	-- Make sure we don't leave 'xref' if we can't find the dictator
	SELECT @attendingFirst = NULL
	SELECT @attendingLast = NULL
	SELECT @attendingFirst = FirstName, @attendingLast = LastName FROM Dictators WHERE EHRProviderID = @Attending AND ClinicID = @ClinicID
END

-- Bail if nothing changed (particularly for API clients that we keep getting the same messages)
DECLARE @Existing INT

SELECT @Existing = COUNT(*) FROM Schedules
WHERE
	ClinicID = @ClinicID AND 
	AppointmentID = @AppointmentID AND
	AppointmentDate = @AppointmentDate AND
	PatientID = @PatientID AND
	ISNULL (EHREncounterID, '') = ISNULL (@EncounterID, '') AND
	ISNULL (Attending, '') = ISNULL (@Attending, '') AND
	LocationID = @LocationID AND
	LocationName = @LocationName AND
	ReasonID = @ReasonID AND
	ReasonName = @ReasonName AND
	ResourceID = @ResourceID AND
	ResourceName = @ResourceName AND
	Status = @Status AND
	ISNULL (AdditionalData, '') = ISNULL (@AdditionalData, '') AND
	ISNULL (ReferringID, '') = ISNULL (@ReferringID, '') AND
	ISNULL (ReferringName, '') = ISNULL (@referringName, '') AND
	ISNULL (AttendingFirst, '') = ISNULL (@attendingFirst, '') AND
	ISNULL (AttendingLast, '') = ISNULL (@attendingLast, '')

IF @Existing > 0 BEGIN RETURN END

UPDATE Schedules 
SET 
	AppointmentDate = @AppointmentDate, 
	PatientID = @PatientID,
	EHREncounterID = @EncounterID,
	Attending = @Attending,
	LocationID = @LocationID,
	LocationName = ISNULL(@LocationName,''),
	ReasonID = @ReasonID,
	ReasonName = @ReasonName,
	ResourceID = @ResourceID,
	ResourceName = @ResourceName,
	Status = @Status,
	AdditionalData = @AdditionalData,
	ReferringID = @ReferringID,
	ReferringName = @referringName,
	AttendingFirst = @attendingFirst,
	AttendingLast = @attendingLast,
	RowProcessed = 0,
	Type = @Type,
	ChangedOn = GETDATE()
OUTPUT Inserted.ScheduleID INTO @ScheduleID
WHERE ClinicID = @ClinicID and AppointmentID = @AppointmentID

IF @@ROWCOUNT = 0
	BEGIN
	
	INSERT INTO Schedules (ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, referringID, ReferringName, AttendingFirst, AttendingLast, Type, CreateDate, ChangedOn)
	OUTPUT Inserted.ScheduleID INTO @ScheduleID	
	VALUES 
	(@ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EncounterID, @Attending, @LocationID, ISNULL(@LocationName,''), @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, @AdditionalData, @ReferringID, @referringName, @attendingFirst, @attendingLast, @type, GETDATE(), GETDATE())
	
	END

INSERT INTO SchedulesTracking (ScheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ChangedOn, ChangedBy, referringID, ReferringName, AttendingFirst, AttendingLast, Type)
SELECT ScheduleID, @ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EncounterID, @Attending, @LocationID, ISNULL(@LocationName,''), @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, @AdditionalData, GETDATE(), 'HL7', @referringID, @referringname, @AttendingFirst, @attendingLast, @Type
FROM @ScheduleID

END
GO
