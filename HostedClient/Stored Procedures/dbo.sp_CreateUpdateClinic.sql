SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/5/2014
-- Description: SP used to Create / Update Clinic Records from AC
-- =============================================
/*
--x
--x Revision history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include Ticket#
--x_____________________________________________________________________________
--x   1    | 11/10/2015  | sharif shaik        | Bug 4669 - incresed size for the @EHRLocationID varchar(500) from varchar(50)
--x   2    | 04/12/2016  | Santhosh            | #5460 - Chubbs Ticket
--x
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
*/
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
	@EHRLocationID varchar(500),
	@ClinicCode varchar(20),
	@DisableUpdateAlert bit,
	@ExcludeStat bit,
	@AutoEnrollDevices bit,
	@CRFlagType int,
	@DisablePatientImages bit,
	@PortalTimeOut int,
	@DaysToRestPassword int,
	@PreviousPasswordCount int,
	@PasswordMinCharacters int,
	@FailedPasswordLockCount int,
	@TimeZoneId int,
	@ForceCRStartDate datetime = null,
	@ForceCREndDate datetime = null,
	@SRETypeID int = -1,
	@RealTimeClinicIP varchar(50) = null,
	@RealTimeClinicPortNo int = null,
	@RealTimeEnabled bit = 0,
	@RhythmWorkFlowID INT = null,
	@AppSetting_DisableSendToTranscription BIT = 0
) AS 
BEGIN
	
	IF NOT EXISTS(SELECT * FROM Clinics where ClinicID = @ClinicID)
	BEGIN
		DECLARE @DEF_PortalTimeout INT
		DECLARE @DEF_DaysToResetPassword INT
		DECLARE @DEF_PreviousPasswordCount INT
		DECLARE @DEF_PasswordMinCharacter INT
		DECLARE @DEF_FailedPasswordLockoutCount INT

		SET @DEF_PortalTimeout = (select ConfigValue from systemconfiguration where ConfigKey = 'DEF_PortalTimeout')
		SET @DEF_DaysToResetPassword = (select ConfigValue from systemconfiguration where ConfigKey = 'DEF_DaysToResetPassword')
		SET @DEF_PreviousPasswordCount = (select ConfigValue from systemconfiguration where ConfigKey = 'DEF_PreviousPasswordCount')
		SET @DEF_PasswordMinCharacter = (select ConfigValue from systemconfiguration where ConfigKey = 'DEF_PasswordMinCharacter')
		SET @DEF_FailedPasswordLockoutCount = (select ConfigValue from systemconfiguration where ConfigKey = 'DEF_FailedPasswordLockoutCount')
		
		INSERT INTO Clinics(ClinicId,Name,MobileCode,AccountManagerID,ExpressQueuesEnabled,ImageCaptureEnabled,PatientClinicalsEnabled,Deleted,EHRVendorID,EHRClinicID,EHRLocationID,ClinicCode,DisableUpdateAlert,CRFlagType,ForceCRStartDate,ForceCREndDate,ExcludeStat,AutoEnrollDevices,SRETypeID,DisablePatientImages,PortalTimeout,DaysToResetPassword,PreviousPasswordCount,PasswordMinCharacters,FailedPasswordLockoutCount,TimeZoneId,RealTimeClinicIP,RealTimeClinicPortNo,RealTimeEnabled,RhythmWorkFlowID,AppSetting_DisableSendToTranscription)
		VALUES(@ClinicId,@Name, @MobileCode, @AccountManagerID, @ExpressQueuesEnabled, @ImageCaptureEnabled, @PatientClinicalsEnabled, @Deleted, @EHRVendorID, @EHRClinicID, @EHRLocationID, @ClinicCode, @DisableUpdateAlert, @CRFlagType, @ForceCRStartDate, @ForceCREndDate, @ExcludeStat, @AutoEnrollDevices, @SRETypeID, @DisablePatientImages, @DEF_PortalTimeout, @DEF_DaysToResetPassword, @DEF_PreviousPasswordCount, @DEF_PasswordMinCharacter, @DEF_FailedPasswordLockoutCount, @TimeZoneId, @RealTimeClinicIP, @RealTimeClinicPortNo, @RealTimeEnabled, @RhythmWorkFlowID, @AppSetting_DisableSendToTranscription)

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
						   AutoEnrollDevices = @AutoEnrollDevices,
						   SRETypeID = @SRETypeID,
						   DisablePatientImages = @DisablePatientImages,
						   PortalTimeout = @PortalTimeOut,
						   DaysToResetPassword = @DaysToRestPassword,
						   PreviousPasswordCount = @PreviousPasswordCount,
						   PasswordMinCharacters = @PasswordMinCharacters,
						   FailedPasswordLockoutCount = @FailedPasswordLockCount,
						   TimeZoneId = @TimeZoneId,
						   RealTimeClinicIP = @RealTimeClinicIP,
						   RealTimeClinicPortNo = @RealTimeClinicPortNo,
						   RealTimeEnabled = @RealTimeEnabled,
						   RhythmWorkFlowID = @RhythmWorkFlowID,
						   AppSetting_DisableSendToTranscription = @AppSetting_DisableSendToTranscription
		WHERE ClinicId = @ClinicID

		IF (@EHRVendorID = 2)
		BEGIN
			IF EXISTS(select * from clinicapis where clinicid = @ClinicID)
			BEGIN
				UPDATE ClinicAPIs SET ConnectionString = 'PracticeID='+@EHRClinicID+';DepartmentID=1' WHERE ClinicId = @ClinicID
			END
			ELSE
			BEGIN
				INSERT INTO ClinicAPIs(ClinicId, ConnectionString) VALUES(@ClinicID, 'PracticeID='+@EHRClinicID+';DepartmentID=1')
			END
		END
	END
	
	SELECT ClinicID from Clinics where ClinicCode = @ClinicCode
END



GO
