
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/28/2014
-- Description: SP used to Create new Dictator accounts
-- Updated: 11/10/2014 - Changed the sproc to allow update or insert
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateDictator] (
	@DictatorName varchar(50),
	@ClinicID smallint,
	@DefaultJobTypeID int,
	@DefaultQueueID int,
	@Password varchar(64),
	@Salt varchar(32),
	@FirstName varchar(100),
	@MI varchar(100),
	@LastName varchar(100),
	@Suffix varchar(100),
	@Initials varchar(20),
	@Signature varchar(1000),
	@EHRProviderID varchar(36),
	@EHRProviderAlias varchar(36),
	@VRMode smallint,
	@CRFlagType int,
	@ForceCRStartDate datetime,
	@ForceCREndDate datetime,
	@ExcludeStat bit,
	@UserId int,
	@SreTypeId int = -1,
	@SignatureImage varbinary(max) = null,
	@ImageName varchar(100) = null
) AS 
BEGIN
	BEGIN TRY 
		BEGIN TRANSACTION
			IF NOT EXISTS(select * from Dictators where ClinicID = @ClinicID and DictatorName = @DictatorName)
			BEGIN
				INSERT INTO Dictators(DictatorName,ClinicID,Deleted,DefaultJobTypeID,DefaultQueueID,Password,Salt,FirstName,MI,LastName,Suffix,Initials,Signature,EHRProviderID,EHRProviderAlias,VRMode,CRFlagType,ForceCRStartDate,ForceCREndDate,ExcludeStat,SignatureImage,ImageName,UserId,SreTypeId)
				VALUES(@DictatorName,@ClinicID,0,@DefaultJobTypeID,@DefaultQueueID,@Password,@Salt,@FirstName,@MI,@LastName,@Suffix,@Initials,@Signature,@EHRProviderID,@EHRProviderAlias,@VRMode,@CRFlagType,@ForceCRStartDate,@ForceCREndDate,@ExcludeStat,@SignatureImage,@ImageName,@UserId,@SreTypeId)
			END
			ELSE
			BEGIN
				UPDATE Dictators SET DefaultJobTypeID = @DefaultJobTypeID,
									 DefaultQueueID = @DefaultQueueID,
									 Password = @Password,
									 Salt = @Salt,
									 FirstName = @FirstName,
									 MI = @MI,
									 LastName = @LastName,
									 Suffix = @Suffix,
									 Initials = @Initials,
									 Signature = @Signature,
									 EHRProviderID = @EHRProviderID,
									 EHRProviderAlias = @EHRProviderAlias,
									 VRMode = @VRMode,
									 CRFlagType = @CRFlagType,
									 ForceCRStartDate = @ForceCRStartDate,
									 ForceCREndDate = @ForceCREndDate,
									 ExcludeStat = @ExcludeStat,
									 SignatureImage = @SignatureImage,
									 ImageName = @ImageName,
									 UserId = @UserId,
									 SreTypeId = @SreTypeId
				WHERE ClinicID = @ClinicID and DictatorName = @DictatorName
			END
	
			IF EXISTS(SELECT * FROM UserClinicXref WHERE UserId = @UserId AND ClinicId = @ClinicID)
			BEGIN
				UPDATE UserClinicXref SET IsDeleted = 0 WHERE UserId = @UserId AND ClinicId = @ClinicID
			END
			ELSE
			BEGIN
				INSERT INTO UserClinicXref VALUES (@UserId, @ClinicID, 0)
			END

			SELECT DictatorId from Dictators where ClinicID = @ClinicID and DictatorName = @DictatorName	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
				ROLLBACK TRANSACTION
				DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
				SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrMsg, @ErrSeverity, 1)
			END
	END CATCH	
END


GO
