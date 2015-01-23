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

	SELECT * FROM UserInvitations

	SELECT @InviteId=UserInvitationId, @cur_clinicid=ClinicId, @cur_requestuserid=RequestingUserId, @cur_RoleId=RoleId, @cur_DemoUser=IsDemoUser
	FROM UserInvitations
	WHERE SUBSTRING(SecurityToken, 0, CHARINDEX('-', SecurityToken, 0)) = @RegistrationCode

	-- Create User entry in the DB
	INSERT INTO Users(UserName,ClinicId,LoginEmail,Name,Password,Salt) VALUES(@EmailAddress, @cur_clinicid, @EmailAddress, @FirstName + ' ' + @LastName, @Password, @Salt)
	SET @UserId = (SELECT UserId from Users where UserName = @EmailAddress)

	UPDATe UserInvitations SET RegisteredUserId = @UserId WHERE UserInvitationId = @InviteId

	IF (@cur_DemoUser = 1)
	BEGIN
		DECLARE @DictatorUserName VARCHAR(100)
		DECLARE @QueueId INT
		DECLARE @DefaultJobTypeId INT
		DECLARE @Initials VARCHAR(3)
		DECLARE @Signature VARCHAR(100)

		SET @DictatorUserName = (SELECT SUBSTRING(@FirstName,0,1) + @LastName)
		SET @Initials = (SELECT SUBSTRING(@FirstName,0,1) + SUBSTRING(@MI,0,1) + SUBSTRING(@LastName,0,1))
		SET @Signature = @FirstName + ' ' + @MI + ' ' + @LastName
		SELECT * FROM JOBTYPES WHERE ClinicId = 227

		-- create queue for dictator
		INSERT INTO Queues(ClinicId,Name,Description,IsDictatorQueue,Deleted) VALUES(@cur_clinicid, @DictatorUserName, 'Default Dictator Queue', 1, 0)
		SET @QueueId = (SELECT QueueID FROM Queues where ClinicId = @cur_clinicid and Name = @DictatorUserName)

		-- create dictator in hosted db
		INSERT INTO Dictators(DictatorName,ClinicID,Deleted,DefaultJobTypeID,DefaultQueueID,Password,Salt,FirstName,MI,LastName,Suffix,Initials,Signature,EHRProviderID,EHRProviderAlias,VRMode,CRFlagType,ExcludeStat)
		VALUES(@DictatorUserName,@cur_clinicid,0,@DefaultJobTypeId,@QueueId,'','',@FirstName,@MI,@LastName,'',@Initials,@Signature,'','',99,0,0)

		-- assign dictator to queue


		-- create backend contact
		-- create backend dictator
		-- Create 50 or so jobs... etc
	END


END


GO
