SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jonathan Pobst
-- Create date: Nov 20, 2013
-- Description:	Used to migrate data from an old PG schema to the new SQL schema
-- =============================================
CREATE PROCEDURE [dbo].[MigrateJob]
	@ClinicID smallint,

	-- Job Data
	@OriginalJobNumber varchar(20),
	@JobTypeID int,
	@OwnerDictatorID int,
	@Status smallint,
	@Stat bit,
	@AdditionalData varchar(max),

	-- Dictation Data
	@DictatorID int,
	@QueueID int,
	@DictationStatus smallint,
	@Duration smallint,
	@MachineName varchar(50),
	@FileName varchar(255),

	-- Encounter Data
	@AppointmentDate datetime,
	@MRN varchar(50),
	@AppointmentID varchar(100),

	-- Schedule Data
	@EHREncounterID varchar(50),
	@Attending varchar(50),
	@LocationID varchar(50),
	@LocationName varchar(100),
	@ReasonID varchar(50),
	@ReasonName varchar(200),
	@ResourceID varchar(50),
	@ResourceName varchar(100),
	@ReferringID varchar(50),
	@ReferringName varchar(100),
	@AttendingFirst varchar(120),
	@AttendingLast varchar(120),

	-- Patient Data
	@FirstName varchar(100),
	@MI varchar(100),
	@LastName varchar(100),
	@Gender varchar(5),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@City varchar(100),
	@State varchar(4),
	@Zip varchar(10),
	@DOB varchar(20),
	@Phone1 varchar(25),
	@Fax1 varchar(25)
AS

BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
BEGIN TRANSACTION;

	DECLARE @ScheduleID bigint
	DECLARE @PatientID int
	DECLARE @EncounterID bigint

-- Not a generic job
IF @AppointmentID IS NOT NULL AND LEN (@AppointmentID) > 0
BEGIN
	-- Find or Create the Patient
	SELECT @PatientID = PatientID FROM Patients WHERE ClinicID = @ClinicID AND MRN = @MRN

	IF @PatientID IS NULL 
	BEGIN
		INSERT INTO Patients (ClinicID, MRN, AlternateID, FirstName, MI, LastName, Suffix, Gender, Address1, Address2, City, State, Zip, DOB, Phone1, Phone2, Fax1, Fax2)
		VALUES (@ClinicID, @MRN, '', @FirstName, @MI, @LastName, '', @Gender, @Address1, @Address2, @City, @State, @Zip, '', @Phone1, '', @Fax1, '')

		SELECT @PatientID = SCOPE_IDENTITY ()
	END

	-- Find or Create the Schedule (It might already exist if we have 2 jobs for one appointment)
	SELECT @ScheduleID = ScheduleID FROM Schedules WHERE ClinicID = @ClinicID AND AppointmentID = @AppointmentID AND PatientID = @PatientID

	IF @ScheduleID IS NULL
	BEGIN
		INSERT INTO Schedules (ClinicID, AppointmentDate, PatientID, AppointmentID, EHREncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, RowProcessed, ReferringID, ReferringName, AttendingFirst, AttendingLast)
		VALUES (@ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EHREncounterID, @Attending, @LocationID, @LocationName, @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, '', 1, @ReferringID, @ReferringName, @AttendingFirst, @AttendingLast)

		SELECT @ScheduleID = SCOPE_IDENTITY ()

		-- Create the SchedulesTracking row
		INSERT INTO SchedulesTracking (ScheduleID, ClinicID, AppointmentDate, PatientID, AppointmentID, EncounterID, Attending, LocationID, LocationName, ReasonID, ReasonName, ResourceID, ResourceName, Status, AdditionalData, ReferringID, ReferringName, AttendingFirst, AttendingLast, ChangedOn, ChangedBy)
		VALUES (@ScheduleID, @ClinicID, @AppointmentDate, @PatientID, @AppointmentID, @EHREncounterID, @Attending, @LocationID, @LocationName, @ReasonID, @ReasonName, @ResourceID, @ResourceName, @Status, '', @ReferringID, @ReferringName, @AttendingFirst, @AttendingLast, GETDATE (), 'Import')
	END
END
ELSE
BEGIN
-- Generic job
	SELECT @PatientID = GenericPatientID FROM SystemSettings WHERE ClinicID = @ClinicID
	SELECT @ScheduleID = NULL
END

	-- Find or Create the Encounter
	SELECT @EncounterID = EncounterID FROM Encounters WHERE PatientID = @PatientID AND ScheduleID = @ScheduleID AND AppointmentDate = @AppointmentDate

	IF @EncounterID IS NULL
	BEGIN
		INSERT INTO Encounters (PatientID, ScheduleID, AppointmentDate)
		VALUES (@PatientID, @ScheduleID, @AppointmentDate)
	
		SELECT @EncounterID = SCOPE_IDENTITY ()
	END

	-- Create the Job
	DECLARE @JobNumberPrefix varchar(6)
	DECLARE @JobNumber varchar(20)
	DECLARE @JobID bigint

	SELECT @JobNumberPrefix = LEFT (@OriginalJobNumber, 6)
	SELECT @JobNumber =
		CASE WHEN MAX (JobNumber) IS NULL THEN @JobNumberPrefix + '000000'
		ELSE MAX (JobNumber) END
		FROM Jobs WHERE LEFT (JobNumber, 6) = @JobNumberPrefix

	SELECT @JobNumber = CAST ((CAST (@JobNumber AS bigint) + 1) AS varchar(20))

	IF @AdditionalData IS NOT NULL SELECT @AdditionalData = REPLACE (@AdditionalData, '{jobnum}', @JobNumber)

	INSERT INTO Jobs (JobNumber, ClinicID, EncounterID, JobTypeID, OwnerDictatorID, Status, Stat, Priority, AdditionalData)
	VALUES (@JobNumber, @ClinicID, @EncounterID, @JobTypeID, @OwnerDictatorID, @Status, @Stat, 0, @AdditionalData)

	SELECT @JobID = SCOPE_IDENTITY ()

	-- Update additional data in schedule row
	IF @ScheduleID IS NOT NULL UPDATE Schedules SET AdditionalData = @AdditionalData WHERE ScheduleID = @ScheduleID

	-- Create the JobsTracking row
	INSERT INTO JobsTracking (JobID, Status, ChangeDate, ChangedBy)
	VALUES (@JobID, @Status, GETDATE (), 'Import - ' + @OriginalJobNumber)

	-- Create the Dictation
	DECLARE @DictationTypeID int
	DECLARE @DictationID bigint

	SELECT @DictationTypeID = DictationTypeID FROM DictationTypes WHERE JobTypeID = @JobTypeID

	INSERT INTO Dictations (JobID, DictationTypeID, DictatorID, QueueID, Status, Duration, MachineName, FileName, ClientVersion)
	VALUES (@JobID, @DictationTypeID, @DictatorID, @QueueID, @DictationStatus, @Duration, @MachineName, @FileName, CASE WHEN @MachineName <> '' THEN 'Imported' ELSE '' END)

	SELECT @DictationID = SCOPE_IDENTITY ()

	-- Create the DictationsTracking row
	INSERT INTO DictationsTracking (DictationID, Status, ChangeDate, ChangedBy)
	VALUES (@DictationID, @DictationStatus, GETDATE (), 'Import')

	SELECT @JobID;
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    	ROLLBACK TRANSACTION;

    DECLARE
    	@ERROR_SEVERITY INT,
    	@ERROR_STATE	INT,
    	@ERROR_NUMBER	INT,
    	@ERROR_LINE		INT,
    	@ERROR_MESSAGE	NVARCHAR(4000);

    SELECT
    	@ERROR_SEVERITY = ERROR_SEVERITY(),
    	@ERROR_STATE	= ERROR_STATE(),
    	@ERROR_NUMBER	= ERROR_NUMBER(),
    	@ERROR_LINE		= ERROR_LINE(),
    	@ERROR_MESSAGE	= ERROR_MESSAGE();

    RAISERROR('Msg %d, Line %d, :%s',
    	@ERROR_SEVERITY,
    	@ERROR_STATE,
    	@ERROR_NUMBER,
    	@ERROR_LINE,
    	@ERROR_MESSAGE);
END CATCH
END
GO
