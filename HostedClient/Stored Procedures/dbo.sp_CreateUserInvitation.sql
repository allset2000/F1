
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Santhosh Mukk
-- Create date: 01/14/2015
-- Description: SP used to Create new Invitation
-- Modified By: Mikayil Bayramov,Raghu A
-- Modified On: 9/25/2015,07/01/2015
-- Modification Details: Added validation for User Role(s) and Clinic,
-- PendingRegStatus flag value added  and @IsMobileSMUser=1 means it is coming from mobile or other web application
-- Modification Code: #001
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUserInvitation]
(
	@FirstName VARCHAR(100) = '',
	@MI VARCHAR(100) = '',
	@LastName VARCHAR(100) = '',
	@EmailAddress VARCHAR(100) = '',
	@PhoneNumber VARCHAR(15) = '',
	@ClinicId INT = -1,
	@InvitationMethod INT,
	@RoleId VARCHAR(500) = '',
	@SecurityToken VARCHAR(50),
	@InvitationTypeId INT,
	@RequestingUserId INT,
	@InvitationMessage VARCHAR(1500),
	@IsMobileSMUser BIT=0 --1 

)
AS
BEGIN
	/*
	--Modification: #001
	If role id is:
		1) negative number (this value can be set from Dictate API),
		2) is null
		3) empty
	then it is interpreted as no role.
	In this case get the default role RUDefualtRole.
	*/
	DECLARE @UserId INT
	DECLARE @UserInvitationId INT

	IF(ISNULL(@RoleId, '-1') = '-1' OR LEN(LTRIM(RTRIM(@RoleId))) <= 0) BEGIN
		IF EXISTS(select 1 from SystemConfiguration where ConfigKey = 'RUDefualtRole') BEGIN
			SET @RoleId = (select ConfigValue from SystemConfiguration where ConfigKey = 'RUDefualtRole')
		END
		ELSE BEGIN
			RAISERROR ('Server Configuration not setup', 16, 1);
		END
	END

	/*
	--Modification: #001
	If Clinic Id is less than zero (negative number) or is null, 
	then get the default clinic id from SMDefaultClinic
	*/
	IF(@ClinicId < 0 OR @ClinicId IS NULL) BEGIN
		IF EXISTS(select 1 from SystemConfiguration where ConfigKey = 'SMDefaultClinic') BEGIN
			SET @ClinicId = (select ConfigValue from SystemConfiguration where ConfigKey = 'SMDefaultClinic')
		END
		ELSE BEGIN
			RAISERROR ('Server Configuration not setup',16,1);
		END
	END

	INSERT INTO [dbo].[UserInvitations]
			   ([FirstName]
			   ,[MI]
			   ,[LastName]
			   ,[EmailAddress]
			   ,[PhoneNumber]
			   ,[InvitationSent]
			   ,[ClinicId]
			   ,[InvitationMethod]
			   ,[RoleId]
			   ,[SecurityToken]
			   ,[DateTimeInvitationSent]
			   ,[InvitationTypeId]
			   ,[RequestingUserId]
			   ,[DateTimeRequested]
			   ,[InvitationMessage]
			   ,[PendingRegStatus]
			   )
		 VALUES
			   (@FirstName
			   ,@MI
			   ,@LastName
			   ,@EmailAddress
			   ,@PhoneNumber
			   ,0
			   ,@ClinicId
			   ,@InvitationMethod
			   ,@RoleId
			   ,@SecurityToken
			   ,GETDATE()
			   ,@InvitationTypeId
			   ,@RequestingUserId
			   ,GETDATE()
			   ,@InvitationMessage
			   ,1)    

	
			--BEGIN START Added for invite new user with message #5518#
			 SET @UserInvitationId= SCOPE_IDENTITY()

			 IF(@IsMobileSMUser=1)
			   BEGIN

						INSERT INTO dbo.Users(UserName,FirstName,MI,LastName,ClinicId,LoginEmail,Name,Password,Salt) 
							   VALUES(@EmailAddress, @FirstName, @MI, @LastName, @ClinicId, @EmailAddress, @FirstName + ' ' + @LastName, NEWID(), NEWID())

						   SET @UserId = SCOPE_IDENTITY()	
						   
						   INSERT INTO UserClinicXref
									   (UserId, ClinicId, IsDeleted)
								 VALUES(@UserId,@ClinicId,0)
					
				  UPDATE dbo.UserInvitations SET RegisteredUserId = @UserId WHERE UserInvitationId = @UserInvitationId 

			END
	    --END START
END
GO
