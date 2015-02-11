
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/21/2015
-- Description: SP used to Register a new user, and create the useraccount defined
-- =============================================
CREATE PROCEDURE [dbo].[sp_RegisterNewUser]
(
	@RegistrationCode varchar(10),
	@FirstName varchar(100),
	@LastName varchar(100),
	@MI varchar(100),
	@EmailAddress varchar(100),
	@Password varchar(64),
	@Salt varchar(32),
	@PhoneNumber varchar(20)
)
AS
BEGIN
	DECLARE @cur_clinicid INT
	DECLARE @cur_requestuserid INT
	DECLARE @cur_RoleId INT
	DECLARE @cur_DemoUser bit
	DECLARE @UserId INT
	DECLARE @InviteId INT
    DECLARE @ShortCode varchar(10)

	IF @MI is null BEGIN SET @MI = '' END

	SET @ShortCode = SUBSTRING(@RegistrationCode, 0, CHARINDEX('-',@RegistrationCode,0))
	
	SELECT @InviteId=UserInvitationId, @cur_clinicid=ClinicId, @cur_requestuserid=RequestingUserId, @cur_RoleId=RoleId, @cur_DemoUser=IsDemoUser
	FROM UserInvitations
	WHERE SUBSTRING(SecurityToken, 0, CHARINDEX('-', SecurityToken, 0)) = @ShortCode

	-- Create User entry in the DB
	INSERT INTO Users(UserName,ClinicId,LoginEmail,Name,Password,Salt) VALUES(@EmailAddress, @cur_clinicid, @EmailAddress, @FirstName + ' ' + @LastName, @Password, @Salt)
	SET @UserId = (SELECT UserId from Users where UserName = @EmailAddress)

	-- Add User Role Xref
	IF(@cur_RoleId <= 0)
	BEGIN
		SET @cur_RoleId = (SELECT TOP 1 RoleId FROM Roles WHERE RoleName = 'Mobile Secure Messaging')
	END
	INSERT INTO UserRoleXref(UserId,RoleId,IsDeleted) VALUES(@UserId,@cur_RoleId,0)

	-- Set the UserId mapping in invitations table, this denotes the user has been registered
	UPDATE UserInvitations SET RegisteredUserId = @UserId WHERE UserInvitationId = @InviteId

	IF (@cur_DemoUser = 1)
	BEGIN
		DECLARE @DictatorUserName VARCHAR(100)
		DECLARE @QueueId INT
		DECLARE @DefaultJobTypeId INT
		DECLARE @Initials VARCHAR(3)
		DECLARE @Signature VARCHAR(100)
		DECLARE @DictatorId INT
		DECLARE @FullName varchar(200)
		DECLARE @BackendDictator varchar(100)
		DECLARE @ClinicCode varchar(10)
		DECLARE @ContactId INT

		SET @DictatorUserName = LOWER((SELECT SUBSTRING(@FirstName,1,3) + @LastName))
		SET @Initials = (SELECT SUBSTRING(@FirstName,0,1) + SUBSTRING(@LastName,0,1))
		SET @Signature = @FirstName + ' ' + @LastName
		SET @DefaultJobTypeId = (SELECT TOP 1 JobTypeId FROM JOBTYPES WHERE ClinicId = @cur_clinicid)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @ClinicCode = (SELECT ClinicCode FROM Clinics where ClinicId = @cur_clinicid)
		SET @BackendDictator = @ClinicCode + @DictatorUserName

		-- create queue for dictator
		IF NOT EXISTS(SELECT QueueID FROM Queues where ClinicId = @cur_clinicid and Name = @DictatorUserName)
		BEGIN
			INSERT INTO Queues(ClinicId,Name,Description,IsDictatorQueue,Deleted) VALUES(@cur_clinicid, @DictatorUserName, 'Default Dictator Queue', 1, 0)
		END
		SET @QueueId = (SELECT TOP 1 QueueID FROM Queues where ClinicId = @cur_clinicid and Name = @DictatorUserName)

		-- create dictator in hosted db
		INSERT INTO Dictators(DictatorName,ClinicID,Deleted,DefaultJobTypeID,DefaultQueueID,Password,Salt,FirstName,MI,LastName,Suffix,Initials,Signature,EHRProviderID,EHRProviderAlias,VRMode,CRFlagType,ExcludeStat,UserId)
		VALUES(@DictatorUserName,@cur_clinicid,0,@DefaultJobTypeId,@QueueId,'','',@FirstName,@MI,@LastName,'',@Initials,@Signature,'','',99,0,0,@UserId)
		SET @DictatorId = (SELECT DictatorId FROM Dictators WHERE DictatorName = @DictatorUserName and ClinicId = @cur_clinicid)

		-- assign dictator to queue
		IF NOT EXISTS(SELECT * FROM Queue_Users WHERE QueueId = @QueueId AND DictatorId = @DictatorId)
		BEGIN
			INSERT INTO Queue_Users(QueueId,DictatorId) VALUES(@QueueId, @DictatorId)
		END

		-- create backend contact
		EXEC Entrada.dbo.sp_CreateUpdateContact 0, 'D', @FullName, @FirstName, @MI, @LastName, @Initials, @BackendDictator, '', '', '', '', 'A',''
		SET @ContactId = (SELECT top 1 ContactId FROM Entrada.dbo.Contacts WHERE UserId = @BackendDictator and ContactType = 'D')

		-- create backend dictator
		INSERT INTO Entrada.dbo.Dictators(ClinicID,DictatorID,ClientUserID,DefaultLocation,FirstName,MI,LastName,Suffix,Initials,TemplatesFolder,User_Code,Signature,VREnabled,ESignatureEnabled,DictatorIdOk,EHRProviderID,EHRAliasID,ProviderType,BillSeparated,PhoneNo,FaxNo,MedicalLicenseNo,Custom1,Custom2,Custom3,Custom4,Custom5)
		VALUES(@cur_clinicid,@BackendDictator,@DictatorUserName,1,@FirstName,@MI,@LastName,'',@Initials,@ClinicCode,'',@Signature,1,'',@ContactId,'','','Provider','','','','','','','','','')

		-- Create 50 test jobs
		DECLARE @JobCnt INT
		SET @JobCnt = 1

		WHILE (@JobCnt < 51)
		BEGIN
			EXEC sp_CreateRandomJobForDictator @cur_clinicid, @DictatorId
			SET @JobCnt = @JobCnt + 1
		END
	END

	-- pass back to the ws (true/false) for user create
	SELECT count(*) from Users WHERE UserId = @UserId

END


GO
