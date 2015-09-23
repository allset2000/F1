
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
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='PST') BEGIN
	INSERT INTO TimeZone(TimeZoneName,GMTOffset) values('PST',-8)
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='MNT') BEGIN
	INSERT INTO TimeZone(TimeZoneName,GMTOffset) values('MNT',-7)
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='CST') BEGIN
	INSERT INTO TimeZone(TimeZoneName,GMTOffset) values('CST',-6)
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='EST') BEGIN
	INSERT INTO TimeZone(TimeZoneName,GMTOffset) values('EST',-5)
END
-- #4355# - End of adds
-- #4355# - Adding default values to system config table
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PortalTimeout') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PortalTimeout','20','Default value for Portal Timeout setting',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_DaysToResetPassword') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_DaysToResetPassword','180','Default value for Days to reset a users password',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PreviousPasswordCount') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PreviousPasswordCount','5','Default value of number of password itterations before a password can be re-used',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_PasswordMinCharacter') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_PasswordMinCharacter','8','Default value for minimum allowed characters in a password',GETDATE(),GETDATE())
END
IF NOT EXISTS (SELECT 1 FROM dbo.SystemConfiguration WHERE ConfigKey = 'DEF_FailedPasswordLockoutCount') BEGIN
	insert into SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('DEF_FailedPasswordLockoutCount','10','Default value for how many failed login attempts locks an account',GETDATE(),GETDATE())
END
-- Update all clinic standard values
UPDATE Clinics SET PortalTimeout = 20, DaysToResetPassword = 180, PreviousPasswordCount = 5, PasswordMinCharacters = 8, FailedPasswordLockoutCount = 10
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
IF EXISTS (SELECT 1 FROM UserInvitations WHERE Deleted is null) BEGIN
	UPDATE UserInvitations SET Deleted = 0 WHERE Deleted is null
END
-- #4355 - End of User InvitationTypes and Migration
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
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-EDITDOCUMENT') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-EDITDOCUMENT','Function - Edit Document',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-APPROVEJOBSINCR') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-APPROVEJOBSINCR','Function - Approve Jobs in CR',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBDETAILSVIEWER-EDITDEMOGRAPHICS') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('FNC-JOBDETAILSVIEWER-EDITDEMOGRAPHICS','Function - Edit Demographics',null,26)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-SECUREMESSENGER') BEGIN
	INSERT INTO Permissions(Code,Name,ParentPermissionID,ModuleId) VALUES('MNU-SECUREMESSENGER','Menu Item - Secure Messenger Page',null,27)
END
-- #0000# - End of adding new data

-- #214# - Clinic Job Delivery Rules
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWRULE-ADD') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWRULE-ADD', 'Function - Add Backend Legacy ROWRule', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWRULE-EDIT') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWRULE-EDIT', 'Function - Edit Backend Legacy ROWRule', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWRULE-CONFIGURE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWRULE-CONFIGURE', 'Function - Configure Backend Legacy ROWRule', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWRULE-DELETE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWRULE-DELETE', 'Function - Delete Backend Legacy ROWRule', NULL, 23)
END

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWLOOKUP-ADD') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWLOOKUP-ADD', 'Function - Add Backend Legacy ROWLookup', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWLOOKUP-EDIT') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWLOOKUP-EDIT', 'Function - Edit Backend Legacy ROWLookup', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-BACKENDLEGACYROWLOOKUP-DELETE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-BACKENDLEGACYROWLOOKUP-DELETE', 'Function - Delete Backend Legacy ROWLookup', NULL, 23)
END
-- #214# - End of adding new data

-- #230# - HL7 Templates
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROWTEMPLATE-ADD') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROWTEMPLATE-ADD', 'Function - Add ROWTemplate', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROWTEMPLATE-EDIT') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROWTEMPLATE-EDIT', 'Function - Edit ROWTemplate', NULL, 23)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROWTEMPLATE-DELETE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROWTEMPLATE-DELETE', 'Function - Delete ROWTemplate', NULL, 23)
END
-- #230# - End of adding new data

-- #460# - NCP - User Mgmt - Restrict User permissions
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ADMINCONSOLE-ACCESS') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ADMINCONSOLE-ACCESS', 'Function - Allow Admin Console Access and Roles', NULL, 21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USER-ADD') BEGIN
	INSERT INTO Permissions VALUES ('FNC-USER-ADD', 'Function - Add User', NULL, 21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USER-EDIT') BEGIN
	INSERT INTO Permissions VALUES ('FNC-USER-EDIT', 'Function - Edit User', NULL, 21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-USER-VIEW') BEGIN
	INSERT INTO Permissions VALUES ('FNC-USER-VIEW', 'Function - View User', NULL, 21)
END

IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROLE-ADD') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROLE-ADD', 'Function - Add Role', NULL, 21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROLE-EDIT') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROLE-EDIT', 'Function - Edit Role', NULL, 21)
END
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ROLE-VIEW') BEGIN
	INSERT INTO Permissions VALUES ('FNC-ROLE-VIEW', 'Function - View Role', NULL, 21)
END
-- #460# - End of adding new data

-- #216# - Ability to Delete ExpressLink Configuration
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-EXPLINK-DELETE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-EXPLINK-DELETE', 'Function - Delete Express Link', NULL, 10)
END
-- #216# - End of adding new data

-- #215# - Remove Jobs HostedClient J2D
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-HostedJ2D-REMOVE') BEGIN
	INSERT INTO Permissions VALUES ('FNC-HostedJ2D-REMOVE', 'Function - Hosted J2D  Remove jobs', NULL, 13)
END
-- #215# - End of adding new data


-- #230# Adding new fields / data for HL7 Delivery
UPDATE ExpressLinkConfigurations SET EnableAthenaACK = 0
IF NOT EXISTS (SELECT 1 FROM ROWVariableTypes WHERE Description = 'ColumnName') BEGIN
	INSERT INTO ROWVariableTypes(Description) VALUES('ColumnName')
END
IF NOT EXISTS (SELECT 1 FROM ROWVariableTypes WHERE Description = 'Function') BEGIN
	INSERT INTO ROWVariableTypes(Description) VALUES('Function')
END
IF NOT EXISTS (SELECT 1 FROM ROWVariableTypes WHERE Description = 'CustomValue') BEGIN
	INSERT INTO ROWVariableTypes(Description) VALUES('CustomValue')
END
IF NOT EXISTS (SELECT 1 FROM ROWVariableTypes WHERE Description = 'CustomQuery') BEGIN
	INSERT INTO ROWVariableTypes(Description) VALUES('CustomQuery')
END
IF NOT EXISTS (SELECT 1 FROM DeliveryTypes WHERE Description = 'Expresslink HL7') BEGIN
	INSERT INTO DeliveryTypes (Description) VALUES('Expresslink HL7')
END
IF NOT EXISTS (SELECT 1 FROM DeliveryTypes WHERE Description = 'Expresslink HL7 ACK') BEGIN
	INSERT INTO deliverytypes (description) VALUES('Expresslink HL7 ACK')
END
IF NOT EXISTS (SELECT 1 FROM DeliveryErrorCodes WHERE ErrorCode = 101) BEGIN
	INSERT INTO DeliveryErrorCodes(DeliveryTypeId,ErrorCode,Description) VALUES(6,101,'Template variable ##athenaclinic## - Missing Data: EHRClinicId Missing from Clinics Table')
END
IF NOT EXISTS (SELECT 1 FROM DeliveryErrorCodes WHERE ErrorCode = 102) BEGIN
	INSERT INTO DeliveryErrorCodes(DeliveryTypeId,ErrorCode,Description) VALUES(6,102,'Template variable ##encnbr## - Missing Data: EHR EncounterId missing from Schedules Table')
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##EHRClinicId##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required,ErrorCodeId) VALUES('##EHRClinicId##',1,'EHRClinicId','Athena Hosted ClinicId',1,1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##JobNumber##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required,ErrorCodeId) VALUES('##JobNumber##',1,'JobNumber','Backend JobNumber',1,1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##ClientJobNbr##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##ClientJobNbr##',1,'ClientJobNumber','Hosted Database JobNumber',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatMRN##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatMRN##',1,'MRN','Patient MRN from backend DB',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatLastName##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatLastName##',1,'FirstName','Patient Lastname from backend db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatFirstName##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatFirstName##',1,'LastName','Patient Firstname from backend db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatMI##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatMI##',1,'MI','Patient MI from backend db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatDOB##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatDOB##',1,'HL7DOB','Patient DOB from backend db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##PatAlternateId##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##PatAlternateId##',1,'AlternateID','Patient DOB from backend db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##encnbr##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required,ErrorCodeId) VALUES('##encnbr##',1,'EHREncounterID','EncounterId for the Checked in Appointment',1,2)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##Sections##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##Sections##',1,'EHRFieldName','Fieldname for current section / dictation',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##TemplateDocument##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##TemplateDocument##',1,'Content','Dictation content for the current section',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##Now##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##Now##',2,'DateTime','Current Datetime',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##BEGIN_REPEAT##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##BEGIN_REPEAT##',2,'','Start section of the repeating message for sections',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##END_REPEAT##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##END_REPEAT##',2,'','End section of the repeating message for sections',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##msg_number##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##msg_number##',2,'','Current section in the list of sections on the dictation',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##msg_total##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##msg_total##',2,'','Total number of sectoins for the dictation',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##EHRProviderId##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##EHRProviderId##',1,'EHRProviderId','EHRProvider Id from Hosted db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##EHRProviderAlias##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##EHRProviderAlias##',1,'EHRProviderAlias','EHRProvider Alias from Hosted db',1)
END
IF NOT EXISTS (SELECT 1 FROM ROWTemplateVariables WHERE VariableName = '##ProviderSignature##') BEGIN
	INSERT INTO ROWTemplateVariables(VariableName,VariableTypeId,FieldName,VariableDescription,Required) VALUES('##ProviderSignature##',1,'Signature','Provider Signature from hosted db',1)
END
-- #230# - End
END

GO
