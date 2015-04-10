
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/3/2015
-- Description: SP Used to store all data changes in the CC.3 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC3]
AS
BEGIN
-- #0000# - Adding Data values for PatientDataAccessPermissions
IF NOT EXISTS(select 1 from PatientDataAccessPermissions Where PermissionCode = 0)
BEGIN
	INSERT INTO PatientDataAccessPermissions(PermissionCode, Name,Description,CreatedDate,UpdatedDate) values(0,'None','Cannot have access to patient demographic and/or clinical data',GETDATE(),GETDATE())
END
IF NOT EXISTS(select 1 from PatientDataAccessPermissions Where PermissionCode = 1)
BEGIN
	INSERT INTO PatientDataAccessPermissions(PermissionCode, Name,Description,CreatedDate,UpdatedDate) values(1,'Demographic','Can have access to patient demographic data',GETDATE(),GETDATE())
END
IF NOT EXISTS(select 1 from PatientDataAccessPermissions Where PermissionCode = 2)
BEGIN
	INSERT INTO PatientDataAccessPermissions(PermissionCode, Name,Description,CreatedDate,UpdatedDate) values(2,'Clinical','Can have access to patient demographic and clinical data',GETDATE(),GETDATE())
END
-- #0000# - END Adding Data values for PatientDataAccessPermissions

-- #0000# - Upgraded DB to CC.3 (data changes)
-- Included tickets in the below scripts are as follows:
-- #3398# - Change user permission for dictator management
-- #3402# - Add / Remove Role from all dictators for client
UPDATE DeliveryTypes SET Description = 'HL7 Letter' WHERE DeliveryTypeId = 3
UPDATE EHRVendors SET DeleteMissingAppointments = 1 WHERE EHRVendorId = 1
-- Add new application values
IF NOT EXISTS(select 1 from Applications Where Description = 'Downloader')
BEGIN
	INSERT INTO Applications(Description,PermissionEnabled,IsDeleted,DateCreated,DateUpdated) VALUES('Downloader',0,0,GETDATE(),GETDATE())
END
IF NOT EXISTS(select 1 from Applications Where Description = 'Entrada Mobile')
BEGIN
	INSERT INTO Applications(Description,PermissionEnabled,IsDeleted,DateCreated,DateUpdated) VALUES('Entrada Mobile',1,0,GETDATE(),GETDATE())
END
IF NOT EXISTS(select 1 from Applications Where Description = 'Admin Console')
BEGIN
	INSERT INTO Applications(Description,PermissionEnabled,IsDeleted,DateCreated,DateUpdated) VALUES('Admin Console',1,0,GETDATE(),GETDATE())
END
-- Add Modules
SET IDENTITY_INSERT [dbo].[Modules] ON
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(1,4,'Job List',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(2,4,'Schedule List',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(3,4,'Secure Messaging',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(4,5,'Dictators',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(5,5,'Jobs',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(6,5,'Dictator Queues',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(7,5,'Job Types',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(8,5,'Test Data',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(9,5,'Job Rules',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(10,5,'ExpressLink',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(11,5,'J2D Errors',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(12,5,'Schedules',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(13,5,'J2D',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(14,5,'Import Data',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(15,5,'Backend Jobs',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(16,5,'Editors',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(17,5,'Editor Companies',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(18,5,'Development',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(19,5,'Mobile Invitations',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(20,5,'Clinics',0,GETDATE(),GETDATE())
INSERT INTO Modules(ModuleId,ApplicationId,ModuleName,IsDeleted,DateCreated,DateUpdated) VALUES(21,5,'Entrada Administration',0,GETDATE(),GETDATE())
SET IDENTITY_INSERT [dbo].[Modules] OFF
-- Clear all permissions and Re-Insert permissions mapping them to the correct module
TRUNCATE TABLE Permissions
SET IDENTITY_INSERT [dbo].[Permissions] ON
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(1,'TAB-DICT','Dictators Tab',null,4)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(2,'TAB-JOBS','Jobs Tab',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(3,'TAB-QUEU','Queues Tab',null,6)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(4,'TAB-CONFIG','Configuration Tab',null,18)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(5,'TAB-TEST','Test Data Tab',null,8)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(6,'TAB-JT','Job Types Tab',null,7)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(7,'TAB-CONS','Console Access Tab',null,21)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(8,'TAB-RULES','Rules Tab',null,9)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(9,'TAB-ENTRADA-ACCESS','Console Access for Entrada Administration',null,21)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(10,'TAB-APP-EXCEPTIONS','Application Exceptions Tab',null,18)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(11,'TAB-EXPLINK','Configure ExpressLink Tab',null,10)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(12,'SHOW-DIAGNOSTICS','Show Diagnostics',null,18)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(13,'TAB-J2D-ERRORS','JobDelivery Errors Tab',null,11)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(14,'TAB-SCHEDULES','Schedules Tab',null,12)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(15,'FNC-JOB-UPDATE','Function - Update Jobs',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(16,'FNC-ACK-RESEND','Function - Resend ACKS (Athena)',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(17,'FNC-JOB-RESEND','Function - Resend Job',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(18,'TAB-JOBSTODELIVER','Jobs To Deliver Tab',null,13)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(19,'FNC-J2D-ADD','Function - J2D Queue jobs to be delivered',null,13)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(20,'FNC-J2D-REMOVE','Function - J2D  Remove jobs',null,13)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(21,'FNC-GREENWAY-OVERRIDE','Function - Override Greenway return values',null,11)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(22,'TAB-IMPORTDATA','Import Data Tab',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(23,'FNC-IMPORT-DICTATORS','Function - Import Dictators',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(24,'FNC-IMPORT-LOCATIONS','Function - Import Locations for rules',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(25,'FNC-IMPORT-PROVIDERS','Function - Import Providers for rules',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(26,'FNC-IMPORT-REASONS','Function - Import Reasons for rules',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(27,'FNC-CLINIC-ADD','Function - Add Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(28,'FNC-CLINIC-ADDEXISTING','Function - Add Existing Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(29,'FNC-CLINIC-EDIT','Function - Edit Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(30,'TAB-BACKEND-JOBS','Tab - Backend Job Management',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(31,'FNC-JOBTYPE-ADD','Function - Add Jobtype',null,7)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(32,'FNC-JOBTYPE-EDIT','Function - Edit Jobtype',null,7)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(33,'FNC-JOBTYPE-TAGS','Function - Jobtype Tag Management',null,7)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(34,'FNC-BACKENDJOB-FIXRECFAILED','Function - Backend Job Fix Rec Failed',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(35,'FNC-BACKENDJOB-RETRYREC','Function - Backend Job Retry Recognition',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(36,'FNC-JOBS-CLEAR','Function - Clear Jobs from Search screen',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(37,'FNC-IMPORT-FROMSCHEDULES','Function - Import data from scheduling messages',null,14)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(38,'FNC-SCHEDULES-REPROCESS','Function - Reporcess Schedules',null,12)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(39,'FNC-BACKENDJOB-DELETE','Function - Delete Backend Job',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(40,'FNC-BACKENDJOB-UNLOCK','Function - Unlock Backend Job',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(41,'FNC-BACKENDJOB-RELEASE','Function - Releae Backend Job',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(42,'FNC-BACKENDJOB-REPROCESS','Function - Reprocess Backend Job',null,15)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(43,'FNC-JOBS-UNDELETE','Function - Undelete Jobs from Search Screen',null,5)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(44,'FNC-CLINIC-ADDDOCUMNET','Function - Add Document to Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(45,'FNC-CLINIC-EDITDOCUMENT','Function - Edit Document for Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(46,'FNC-CLINIC-DOWNLOADDOCUMENT','Function - Download document for Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(47,'FNC-CLINIC-DELETEDOCUMENT','Function - Delete document for Clinic',null,20)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(48,'TAB-EDITORS','Tab - Editors',null,16)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(49,'FNC-EDITORS-ADD','Function - Add Editors',null,16)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(50,'FNC-EDITORS-EDIT','Function - Edit Editors',null,16)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(51,'TAB-BACKEND-COMPANIES','Tab - Backend Companies',null,17)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(52,'FNC-BACKENDCOMPANIES-ADD','Function - Add Backend Companies',null,17)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(53,'FNC-BACKENDCOMPANIES-EDIT','Function - Edit Backend Companies',null,17)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(54,'FNC-EDITORS-EDITPAY','Function - Edit Editors Pay',null,16)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(55,'FNC-EDITORS-VIEWEDITORPAY','Function - View Editors Pay',null,16)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(56,'FNC-RULES-ADDSCHEDULE','Function - Add Schedule based job building rule',null,9)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(57,'FNC-RULES-ADDORDER','Function - Add Order based job building rule',null,9)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(58,'FNC-RULES-UPDATE','Function - Edit job building rules',null,9)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(59,'TAB-API-SCRATCHPAD','TAB - DEV API ScrathcPAd',null,18)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(60,'MOBILE-JOB-LIST','Access to Mobile Job List',null,1)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(61,'MOBILE-SCHEDULE-LIST','Access to Mobile Schedule List',null,2)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(62,'MOBILE-SECURE-MESSAGING','Access to Mobile Secure Messaging',null,3)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(63,'TAB-INVITATIONS','Tab - Invitations',null,19)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(64,'FNC-INVITATIONS-ADD','Function - Add Invitations',null,19)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(65,'FNC-INVITATION-RESEND','Function - Resend Invitation',null,19)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(66,'FNC-DICTATOR-CHANGEUSER','Function - Change Dictator User',null,4)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(67,'FNC-DICTATORS-ADD','Function - Add New Dictators',null,4)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(68,'FNC-DICTATORS-ADDMASSROLE','Function - Manage Dictator Roles (Mass)',null,4)
INSERT INTO Permissions(PermissionID,Code,Name,ParentPermissionId,ModuleId) VALUES(69,'FNC-CLINIC-ADMINCLINIC','Function - Manage Clinic',null,20)
SET IDENTITY_INSERT [dbo].[Permissions] OFF
-- Add RowOverrideFields
IF NOT EXISTS (select 1 from RowOverrideFields where FieldName = 'DocumentId')
BEGIN
	INSERT INTO ROWOverrideFields(FieldName,EHRVendorId) VALUES('DocumentId',11)
END
-- Add StatusCodes
IF NOT EXISTS (select 1 from StatusCodes where StatusId = 400)
BEGIN
	INSERT INTO StatusCodes(StatusId,Description,Category) VALUES(400,'PROCESSING',2)
END
-- Populate new UserRoleXref table
INSERT INTO UserRoleXref (UserId,RoleId,IsDeleted)
SELECT UserID,RoleID,0 FROM UserRoles
-- Remove old table (no longer used)
DROP TABLE dbo.UserRoles
-- Populate new RolePermissionXref table
INSERT INTO RolePermissionXref (RoleId,PermissionId,IsDeleted)
SELECT RoleId,PermissionId,0 FROM RolePermissions
-- Remove old table (no longer used)
DROP TABLE dbo.RolePermissions
-- Based on the permissions granted already populate all of the "Role / Application" permission mappings
CREATE TABLE #temp_perm
(
	RoleId int,
	ApplicationId int
)
INSERT INTO #temp_perm
select RPX.RoleId,M.ApplicationId from RolePermissionXref RPX
	INNER JOIN Permissions P on P.PermissionId = RPX.permissionid
	INNER JOIN Modules M on M.ModuleId = P.ModuleId
WHILE EXISTS (select 1 from #temp_perm)
BEGIN
	DECLARE @Role int
	DECLARE @App int

	SELECT top 1 @Role = RoleId, @App = ApplicationID FROM #temp_perm

	INSERT INTO RoleApplicationXref(RoleId,ApplicationId,IsDeleted) VALUES(@Role, @App, 0)

	DELETE FROM #temp_perm where RoleId = @Role and ApplicationId = @App
END
DROP TABLE #temp_perm
-- Insert System Configuration Values
INSERT INTO SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('SMDefaultClinic','1','Default Clinicid for SM Invitations from mobile',GETDATE(),GETDATE())
INSERT INTO SystemConfiguration(ConfigKey,ConfigValue,Description,DateCreated,DateUpdated) values('RUDefualtRole','392','Defualt RoleId to be used when a user is registered',GETDATE(),GETDATE())
-- Map new User data
UPDATE Users SET UserName = LoginEmail, SecurityToken = '', FirstName = SUBSTRING(Name,0,(CHARINDEX(' ',Name,0))), LastName = SUBSTRING(Name,(CHARINDEX(' ',Name,0)),LEN(Name) - CHARINDEX(' ',Name,0) + 1), MI=''
	
	
	/*
		Added By Mikayil Bayramov on 4/8/2015
		Add values to LogConfiguration which is centralized cofiguration for Entrada.Logger
	*/
	IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'DICTATE_INTERNAL_API') BEGIN
		INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)
		VALUES('Mobile Dictate Internal WEB API', 'DICTATE_INTERNAL_API', 1, 1, 0, 'inteltamojit@gmail.com', 'noreply@entradahealth.com', 'Failure at Mobile Dictate Internal WEB API', 'smtp.entradahealth.net', 1, 'MobileDictateInternalWebApiErrorLog.txt', 'C:\EntradaLogs\', 1, 0, NULL, NULL, 0, NULL, NULL, GETDATE(), NULL)
		PRINT 'ADDED LOG CONFIGURATION FOR Mobile Dictate Internal WEB API'
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'EXPRESS_LINK_INTERNAL_API') BEGIN
		INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)
		VALUES('Express Link Internal WEB API', 'EXPRESS_LINK_INTERNAL_API', 1, 1, 0, 'inteltamojit@gmail.com', 'noreply@entradahealth.com', 'Failure at Express Link Internal WEB API', 'smtp.entradahealth.net', 1, 'ExpressLinkInternalWebApiErrorLog.txt', 'C:\EntradaLogs\', 1, 0, NULL, NULL, 0, NULL, NULL, GETDATE(), NULL)
		PRINT 'ADDED LOG CONFIGURATION FOR Express Link Internal WEB API'
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'EXPRESS_LINK_PUBLIC_API') BEGIN
		INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate) 
		VALUES ('Express Link Public WEB API', 'EXPRESS_LINK_PUBLIC_API', 1, 1, 0, 'inteltamojit@gmail.com', 'noreply@entradahealth.com', 'Failure at Express Link Public WEB API', 'smtp.entradahealth.net', 1, 'ExpressLinkPublicWebApiErrorLog.txt', 'C:\EntradaLogs\', 1, 0, NULL, NULL, 1, 'http://localhost:58521', 'api/logger/createexceptionlog', GETDATE(), NULL)
		PRINT 'ADDED LOG CONFIGURATION FOR Express Link Public WEB API'
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'SPEECH_RECOGNITION_ENGINE') BEGIN
		INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)
		VALUES ('Speech Recognition Engine', 'SPEECH_RECOGNITION_ENGINE', 1, 0, 0, 'nramadheni@entradahealth.com', 'noreply@entradahealth.com', 'Speech Recognition Engine', 'smtp.entradahealth.net', 1, 'SpeechRecognitionEngineErrorLog.txt', 'C:\EntradaLogs\', 0, 0, NULL, NULL,  0, NULL, NULL, GETDATE(), NULL)
		PRINT 'ADDED LOG CONFIGURATION FOR Speech Recognition Engine'
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'MOBILE_APP') BEGIN
		INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)	  
		VALUES ('Entrada Mobile Application', 'MOBILE_APP', 1, 1, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, GETDATE(), NULL)
		PRINT 'ADDED LOG CONFIGURATION FOR Entrada Mobile Application'
	END
END

GO
