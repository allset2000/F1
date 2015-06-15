
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 5/20/2015
-- Description: SP Used to store all data changes in the D.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_D2]
AS
BEGIN
-- #4355# - Adding new apps to lookup table
IF NOT EXISTS (SELECT 1 FROM dbo.Applications WHERE Description = 'Customer Portal') BEGIN
	INSERT INTO Applications(Description,PermissionEnabled,IsDeleted,DateCreated,DateUpdated) VALUES('Customer Portal',1,0,GETDATE(),GETDATE())
END
-- #4355 - End Adding new apps
-- #4355# - Adding Timezone lookup table values
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='WST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('WST')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='MNT') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('MNT')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='CST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('CST')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='EST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('EST')
END
-- #4355# - End of adds
-- #4355# - Adding default values to system config table
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PortalTimeout') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PortalTimeout','20','Default value for Portal Timeout setting',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_DaysToResetPassword') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_DaysToResetPassword','90','Default value for Days to reset a users password',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PreviousPasswordCount') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PreviousPasswordCount','3','Default value of number of password itterations before a password can be re-used',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PasswordMinCharacter') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PasswordMinCharacter','8','Default value for minimum allowed characters in a password',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_FailedPasswordLockoutCount') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_FailedPasswordLockoutCount','5','Default value for how many failed login attempts locks an account',GETDATE(),GETDATE())
END
-- #4355 - End of config adds
-- #4355 - UserInvitaion Types and migration
IF NOT EXISTS (SELECT 1 FROM dbo.UserInvitationTypes WHERE InvitationTypeName = 'Portal') BEGIN
	insert into UserInvitationTypes(InvitationTypeName) values('Portal')
END
IF NOT EXISTS (SELECT 1 FROM dbo.UserInvitationTypes WHERE InvitationTypeName = 'Mobile Demo') BEGIN
	insert into UserInvitationTypes(InvitationTypeName) values('Mobile Demo')
END
IF NOT EXISTS (SELECT 1 FROM dbo.UserInvitationTypes WHERE InvitationTypeName = 'Secure Messenger') BEGIN
	insert into UserInvitationTypes(InvitationTypeName) values('Secure Messenger')
END
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'UserInvitations' and COLUMN_NAME = 'IsDemoUser') BEGIN
	UPDATE UserInvitations SET InvitationTypeId = 2 where IsDemoUser = 1
	UPDATE UserInvitations SET InvitationTypeId = 3 where IsDemoUser = 0
	ALTER TABLE UserInvitations DROP COLUMN IsDemoUser
END
-- #4355 - End of User InvitationTypes
-- #4355 - Adding new permission codes for epic
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-INVITATION-DELETE') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-INVITATION-DELETE','Function - Delete Invitation',null,19)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USERS-DELETE') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-USERS-DELETE','Function - Delete User',null,21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USERS-UNBLOCK') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-USERS-UNBLOCK','Function - Unblock User',null,21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USERS-RESETPASSWORD') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-USERS-RESETPASSWORD','Function - Reset Users Password',null,21)
END
-- #4355 End of permission code adding
-- #0000# - Adding new modules / permissions for new customer portal
IF NOT EXISTS (SELECT 1 FROM Modules WHERE ModuleName = 'Home Page') BEGIN
	INSERT INTO Modules(ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(6,'Home Page',0,GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM Modules WHERE ModuleName = 'Job Reports') BEGIN
	INSERT INTO Modules(ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(6,'Job Reports',0,GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM Modules WHERE ModuleName = 'Job Details Viewer') BEGIN
	INSERT INTO Modules(ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(6,'Job Details Viewer',0,GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM Modules WHERE ModuleName = 'Secure Messenger') BEGIN
	INSERT INTO Modules(ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(6,'Secure Messenger',0,GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-HOMEPAGE') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('MNU-HOMEPAGE','Menu Item - Home Page',null,24)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-JOBREPORTS') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('MNU-JOBREPORTS','Menu Item - Job Reports Page',null,25)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-JOBDETAILSVIEWER') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('MNU-JOBDETAILSVIEWER','Menu Item - Job Details Page',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-EDITDOCUMENT') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-EDITDOCUMENT','Function - Edit Document',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-APPROVEJOBSINCR') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-APPROVEJOBSINCR','Function - Approve Jobs in CR',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-EDITDEMOGRAPHICS') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-EDITDEMOGRAPHICS','Function - Edit Demographics',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-VIEWONLY') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-VIEWONLY','Function - View Only',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-SECUREMESSENGER') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('MNU-SECUREMESSENGER','Menu Item - Secure Messenger Page',null,27)
END
-- #0000# - End of adding new data
END

GO
