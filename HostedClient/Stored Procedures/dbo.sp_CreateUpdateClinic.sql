SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/5/2014
-- Description: SP used to Create / Update Clinic Records from AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateClinic] (
	@ClinicID smallint,
	@Name varchar(50),
	@MobileCode char(5),
	@AccountManagerID smallint,
	@ExpressQueuesEnabled bit,
	@ImageCaptureEnabled bit,
	@PatientClinicalsEnabled bit,
	@Deleted bit,
	@EHRVendorID smallint,
	@EHRClinicID varchar(50),
	@EHRLocationID varchar(50),
	@ClinicCode varchar(20),
	@DisableUpdateAlert bit,
	@ExcludeStat bit,
	@AutoEnrollDevices bit,
	@CRFlagType int,
	@ForceCRStartDate datetime = null,
	@ForceCREndDate datetime = null
) AS 
BEGIN
	
	IF NOT EXISTS(SELECT * FROM Clinics where ClinicID = @ClinicID)
	BEGIN
		INSERT INTO Clinics(ClinicId,Name,MobileCode,AccountManagerID,ExpressQueuesEnabled,ImageCaptureEnabled,PatientClinicalsEnabled,Deleted,EHRVendorID,EHRClinicID,EHRLocationID,ClinicCode,DisableUpdateAlert,CRFlagType,ForceCRStartDate,ForceCREndDate,ExcludeStat,AutoEnrollDevices)
		VALUES(@ClinicId,@Name, @MobileCode, @AccountManagerID, @ExpressQueuesEnabled, @ImageCaptureEnabled, @PatientClinicalsEnabled, @Deleted, @EHRVendorID, @EHRClinicID, @EHRLocationID, @ClinicCode, @DisableUpdateAlert, @CRFlagType, @ForceCRStartDate, @ForceCREndDate, @ExcludeStat, @AutoEnrollDevices)

		IF (@EHRVendorID = 2)
		BEGIN
			DECLARE @cur_clinicid INT
			SET @cur_clinicid = (SELECT ClinicID from Clinics where ClinicCode = @ClinicCode)

			INSERT INTO ClinicAPIs(ClinicId, ConnectionString) VALUES(@cur_clinicid, 'PracticeID='+@EHRClinicID+';DepartmentID=1')
		END
	END
	ELSE
	BEGIN
		UPDATE Clinics SET Name = @Name,
						   MobileCode = @MobileCode,
						   AccountManagerID = @AccountManagerID,
						   ExpressQueuesEnabled = @ExpressQueuesEnabled,
						   ImageCaptureEnabled = @ImageCaptureEnabled,
						   PatientClinicalsEnabled = @PatientClinicalsEnabled,
						   Deleted = @Deleted, 
						   EHRVendorID = @EHRVendorID, 
						   EHRClinicID = @EHRClinicID, 
						   EHRLocationID = @EHRLocationID, 
						   ClinicCode = @ClinicCode, 
						   DisableUpdateAlert = @DisableUpdateAlert, 
						   CRFlagType = @CRFlagType, 
						   ForceCRStartDate = @ForceCRStartDate, 
						   ForceCREndDate = @ForceCREndDate, 
						   ExcludeStat = @ExcludeStat, 
						   AutoEnrollDevices = @AutoEnrollDevices
		WHERE ClinicId = @ClinicID

		IF (@EHRVendorID = 2)
		BEGIN
			IF EXISTS(select * from clinicapis where clinicid = @ClinicID)
			BEGIN
				UPDATE ClinicAPIs SET ConnectionString = 'PracticeID='+@EHRClinicID+';DepartmentID=1' WHERE ClinicId = @ClinicID
			END
			ELSE
			BEGIN
				INSERT INTO ClinicAPIs(ClinicId, ConnectionString) VALUES(@cur_clinicid, 'PracticeID='+@EHRClinicID+';DepartmentID=1')
			END
		END
	END
	
	SELECT ClinicID from Clinics where ClinicCode = @ClinicCode
END



GO
