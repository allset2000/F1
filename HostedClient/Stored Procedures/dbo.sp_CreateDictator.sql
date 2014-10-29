SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/28/2014
-- Description: SP used to Create new Dictator accounts
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateDictator] (
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
	@SignatureImage varbinary(max) = null,
	@ImageName varchar(100) = null
) AS 
BEGIN
	
	INSERT INTO Dictators(DictatorName,ClinicID,Deleted,DefaultJobTypeID,DefaultQueueID,Password,Salt,FirstName,MI,LastName,Suffix,Initials,Signature,EHRProviderID,EHRProviderAlias,VRMode,CRFlagType,ForceCRStartDate,ForceCREndDate,ExcludeStat,SignatureImage,ImageName)
	VALUES(@DictatorName,@ClinicID,0,@DefaultJobTypeID,@DefaultQueueID,@Password,@Salt,@FirstName,@MI,@LastName,@Suffix,@Initials,@Signature,@EHRProviderID,@EHRProviderAlias,@VRMode,@CRFlagType,@ForceCRStartDate,@ForceCREndDate,@ExcludeStat,@SignatureImage,@ImageName)

	SELECT DictatorId from Dictators where DictatorName = @DictatorName and ClinicID = @ClinicID
		
END

GO
