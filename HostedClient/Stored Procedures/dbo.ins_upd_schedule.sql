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
	@MRN varchar(50),
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
	@attendingLast varchar(120)

AS
BEGIN

DECLARE @patientID INT
DECLARE @orig_enc_id VARCHAR(50)
DECLARE @ScheduleID TABLE (ScheduleID BIGINT)

SET @patientID = (SELECT PatientID FROM Patients WHERE MRN = @MRN and ClinicID = @ClinicID)
SELECT @orig_enc_id = EHRencounterid FROM Schedules WHERE ClinicID = @ClinicID and AppointmentID = @AppointmentID
IF isnull(@orig_enc_id,'') <> ''
BEGIN
	SET @EncounterID = @orig_enc_id
END

UPDATE Schedules 
SET 
	AppointmentDate = @AppointmentDate, 
	PatientID = @PatientID,
	EHREncounterID = @EncounterID,
	Attending = @Attending,
	LocationID = @LocationID,
	LocationName = @LocationName,
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
	RowProcessed = 0
OUTPUT Inserted.ScheduleID INTO @ScheduleID
WHERE ClinicID = @ClinicID and AppointmentID = @AppointmentID

IF @@ROWCOUNT = 0
	BEGIN
	
	INSERT INTO Schedules (ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, referringID, ReferringName, AttendingFirst, AttendingLast)
	OUTPUT Inserted.ScheduleID INTO @ScheduleID	
	VALUES 
	(@ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EncounterID, @Attending, @LocationID, @LocationName, @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, @AdditionalData, @ReferringID, @referringName, @attendingFirst, @attendingLast)	
	
	END

INSERT INTO SchedulesTracking (ScheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ChangedOn, ChangedBy, referringID, ReferringName, AttendingFirst, AttendingLast)
SELECT ScheduleID, @ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EncounterID, @Attending, @LocationID, @LocationName, @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, @AdditionalData, GETDATE(), 'HL7', @referringID, @referringname, @AttendingFirst, @attendingLast
FROM @ScheduleID



END
GO
