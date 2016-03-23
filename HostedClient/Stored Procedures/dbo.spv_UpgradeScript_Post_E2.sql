SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spv_UpgradeScript_Post_E2]
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_post_E2
--X
--X AUTHOR: Sharif Shaik
--X
--X DESCRIPTION: SP Used to store all data changes in the E.2 release
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 08-Jan-2016  | Sharif Shaik			| Initial Design
--X   1    | 11-Jan-2016  | Sharif Shaik			| #4459 - Adding Data to New column of Applications and Module table
--X   2    | 12-Jan-2016  | Santhosh                | #365 - Adding Job Delivery Error Codes
--X   3    | 03-Feb-2016  | Santhosh                | #5478 - Image Only - Admin Console changes.
--X   4    | 09-Feb-2016  | Narender                | #392 - Added New entry into Module and Permission tables for WorkList feature in NCP
--X   5    | 09-Feb-2016  | Baswaraj				| #393 - Added New entry into Module and Permission tables for Delivery ErrorManagement
--X   6    | 10-Feb-2016  | Sharif Shaik			| #5477 - Added new record "Image Only" to table DeliveryTypes
--X   7    | 11-Feb-2016  | Sharif Shaik			| #5477 - Removed above added record and uncommented the commented code
--X   8    | 09-Feb-2016  | Santhosh       			| #000 - Added Permission for Mobile
--X   9    | 19-Feb-2016  | Suresh       			| #734 - Added Permission for Centralized Job Activity Dashboard
--X   10   | 14-Mar-2016  | Baswaraj				| #0000 - Update EHRVendor table to set DeliveryErrorAccess true 
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	
	Update Applications
	SET AppCode = 'EXPRESS_LINK'
	Where [Description] =  'ExpressLink'

	Update Applications
	SET AppCode = 'MIRTH_CONNECT'
	Where [Description] =  'MirthConnect'

	Update Applications
	SET AppCode = 'DOWNLOADER'
	Where [Description] =  'Downloader'

	Update Applications
	SET AppCode = 'MOBILE'
	Where [Description] =  'Entrada Mobile'

	Update Applications
	SET AppCode = 'ADMIN_CONSOLE'
	Where [Description] =  'Admin Console'

	Update Applications
	SET AppCode = 'CUSTOMER_PORTAL'
	Where [Description] =  'Customer Portal'

			
	Update Modules
	SET ModuleCode = upper(AppCode + '_' + replace(ModuleName,' ','_')) 
	From Modules
		INNER JOIN Applications ON Applications.ApplicationId = Modules.ApplicationId


	Delete from [Permissions] where code ='MOBILE-SECURE-MESSAGING-DELETE-MESSAGE'
	IF NOT EXISTS(select 1 from [Permissions] where code ='MOBILE-SECURE-MESSAGING-DELETE-MESSAGE')
	BEGIN
		INSERT INTO  [dbo].[Permissions] SELECT 'MOBILE-SECURE-MESSAGING-DELETE-MESSAGE','Function - Delete Message locally from a chat', NULL,3
	END

	Update [Permissions]
	SET Code = 'MOBILE-JOB-LIST-VIEW'
	Where [Code] =  'MOBILE-JOB-LIST'

	Update [Permissions]
	SET Code = 'MOBILE-SCHEDULE-LIST-VIEW'
	Where [Code] =  'MOBILE-SCHEDULE-LIST'

	Update [Permissions]
	SET Code = 'MOBILE-SECURE-MESSAGING-VIEW'
	Where [Code] =  'MOBILE-SECURE-MESSAGING'

	/*365*/
	IF NOT EXISTS(SELECT 1 FROM ErrorSourceTypes WHERE ErrorSourceType = 'Client')
	BEGIN
		INSERT INTO ErrorSourceTypes (ErrorSourceType) VALUES ('Client')
	END
	IF NOT EXISTS(SELECT 1 FROM ErrorSourceTypes WHERE ErrorSourceType = 'Editing')
	BEGIN
		INSERT INTO ErrorSourceTypes (ErrorSourceType) VALUES ('Editing')
	END
	IF NOT EXISTS(SELECT 1 FROM ErrorSourceTypes WHERE ErrorSourceType = 'System')
	BEGIN
		INSERT INTO ErrorSourceTypes (ErrorSourceType) VALUES ('System')
	END

	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ERRORDEFINITION-ADD') BEGIN
		INSERT INTO Permissions (Code,Name,ParentPermissionID,ModuleId) VALUES ('FNC-ERRORDEFINITION-ADD','Function - Add ErrorDefinition',null,23)
	END
	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ERRORDEFINITION-EDIT') BEGIN
		INSERT INTO Permissions (Code,Name,ParentPermissionID,ModuleId) VALUES ('FNC-ERRORDEFINITION-EDIT','Function - Edit ErrorDefinition',null,23)
	END
	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-ERRORDEFINITION-DELETE') BEGIN
		INSERT INTO Permissions (Code,Name,ParentPermissionID,ModuleId) VALUES ('FNC-ERRORDEFINITION-DELETE','Function - Delete ErrorDefinition',null,23)
	END
	/*365*/

	/*5478*/
	IF NOT EXISTS(SELECT 1 FROM JobTypeCategory WHERE JobTypeCategory = 'Dictation')
	BEGIN
		INSERT INTO JobTypeCategory VALUES (1, 'Dictation')
	END
	IF NOT EXISTS(SELECT 1 FROM JobTypeCategory WHERE JobTypeCategory = 'Image Only')
	BEGIN
		INSERT INTO JobTypeCategory VALUES (2, 'Image Only')
	END
	IF NOT EXISTS(SELECT 1 FROM JobTypeCategory WHERE JobTypeCategory = 'Chat Upload')
	BEGIN
		INSERT INTO JobTypeCategory VALUES (3, 'Chat Upload')
	END

	Update JobTypes SET JobTypeCategoryId = 1 WHERE JobTypeCategoryId IS NULL
	/*5478*/

	/* #392 WORKLIST in NCP */
	IF NOT EXISTS (SELECT 1 FROM Modules WHERE ApplicationId = 6 and ModuleName = 'Job List')
	BEGIN
		SET IDENTITY_INSERT [dbo].[Modules] ON
		INSERT INTO Modules(ModuleId ,ApplicationId , ModuleName, IsDeleted, DateCreated, DateUpdated) values(28, 6, 'Job List', 0,GETDATE(), GETDATE())
		SET IDENTITY_INSERT [dbo].[Modules] OFF
	END
	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'MNU-WORKLIST')
	BEGIN
		INSERT INTO Permissions (Code,Name,ParentPermissionID,ModuleId) VALUES ('MNU-WORKLIST','Menu Item - Job List',null,28)
	END
	/* #392 WORKLIST in NCP */

	/* Start #393 Error Management */
     
-- INSERT RECORD INTO MODULES TABLE 
	IF NOT EXISTS (SELECT '*' FROM [DBO].[MODULES] WHERE MODULEID=31)
	BEGIN
	SET IDENTITY_INSERT [DBO].[MODULES] ON 
		INSERT [DBO].[MODULES] ([MODULEID], [APPLICATIONID], [MODULENAME], [ISDELETED], [DATECREATED], [DATEUPDATED]) 
		VALUES (31, 6, N'ERROR MANAGEMENT', 0, GETDATE(), GETDATE())
	SET IDENTITY_INSERT [DBO].[MODULES] OFF
	END
	------------------------------------
	-- INSERT RECORD INTO PERMISSIONS TABLE 
	------------------------------------
	IF NOT EXISTS(SELECT '*' FROM [DBO].[PERMISSIONS] WHERE CODE='FNC-CLIENTERRORS-VIEW' AND MODULEID=31)
	BEGIN
	SET IDENTITY_INSERT [DBO].[PERMISSIONS] ON 
	INSERT [DBO].[PERMISSIONS] ([CODE], [NAME], [PARENTPERMISSIONID], [MODULEID]) 
	VALUES (N'FNC-CLIENTERRORS-VIEW', N'Function - View only client errors', NULL, 31)
	SET IDENTITY_INSERT [DBO].[PERMISSIONS] OFF
	END
	IF NOT EXISTS(SELECT '*' FROM [DBO].[PERMISSIONS] WHERE CODE='FNC-OVERRIDEVALUES-ADD' AND MODULEID=31)
	BEGIN
	SET IDENTITY_INSERT [DBO].[PERMISSIONS] ON 
	INSERT [DBO].[PERMISSIONS] ([CODE], [NAME], [PARENTPERMISSIONID], [MODULEID]) 
	VALUES (N'FNC-OVERRIDEVALUES-ADD', N'Function - Add override values', NULL, 31)
	SET IDENTITY_INSERT [DBO].[PERMISSIONS] OFF
	END
	----------------------------------------
	--- Update EHRVendor tabel to set ShowDeliveryErrorInNCP to true
	----------------------------------------

	IF NOT EXISTS(SELECT '*' FROM [EntradaHostedClient].[DBO].[EHRVendors] WHERE EHRVendorID=10 AND ShowDeliveryErrorInNCP=1 )
	BEGIN
	UPDATE [EntradaHostedClient].[DBO].[EHRVendors] Set ShowDeliveryErrorInNCP=1 WHERE EHRVendorID=10 -- Allscripts TW
	END

	 IF NOT EXISTS(SELECT '*' FROM [EntradaHostedClient].[DBO].[EHRVendors] WHERE EHRVendorID=2 AND ShowDeliveryErrorInNCP=1 )
	BEGIN
	UPDATE [EntradaHostedClient].[DBO].[EHRVendors] Set ShowDeliveryErrorInNCP=1 WHERE EHRVendorID=2 -- Athena
	END

	 IF NOT EXISTS(SELECT '*' FROM [EntradaHostedClient].[DBO].[EHRVendors] WHERE EHRVendorID=6 AND ShowDeliveryErrorInNCP=1 )
	BEGIN
	UPDATE [EntradaHostedClient].[DBO].[EHRVendors] Set ShowDeliveryErrorInNCP=1 WHERE EHRVendorID=6 -- Greenway
	END
	
	IF NOT EXISTS(SELECT '*' FROM [EntradaHostedClient].[DBO].[EHRVendors] WHERE EHRVendorID=3 AND ShowDeliveryErrorInNCP=1 )
	BEGIN
	UPDATE [EntradaHostedClient].[DBO].[EHRVendors] Set ShowDeliveryErrorInNCP=1 WHERE EHRVendorID=3 -- NextGen
	END
	---------------------------
	-- Insert scripts to ROWOverrideFields to add Fields for Athena and allscripts
	--------------------------

	 IF NOT EXISTS(select * from [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] Where FieldID=6)
		BEGIN
		    SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ON 
			INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ([FieldID], [FieldName], [EHRVendorId]) 
			VALUES (6, N'AthenaEHREncounterID', 2)
			SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] OFF
		END

		IF NOT EXISTS(select * from [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] Where FieldID=7)
		BEGIN
		SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ON 
			INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ([FieldID], [FieldName], [EHRVendorId]) 
			VALUES (7, N'AthenaEHRDocumentTypeID', 2)
			SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] OFF
		END

		IF NOT EXISTS(select * from [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] Where FieldID=8)
		BEGIN
		SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ON 
			INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] ([FieldID], [FieldName], [EHRVendorId]) 
			VALUES (8, N'AthenaEHRDocumentID', 2)
			SET IDENTITY_INSERT [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] OFF
		END

		
		IF EXISTS(select * from [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] Where FieldID=4 and FieldName='DocumentId')
		BEGIN
			Update [ENTRADAHOSTEDCLIENT].[DBO].[ROWOverrideFields] set	FieldName='AllscriptsEHRDocumentID' where FieldID=4
		END

	/* End #393 Error Management */

	/* #000 */
	IF NOT EXISTS(SELECT * FROM Permissions WHERE Code = 'MOBILE-SECURE-MESSAGING-INVITE-CONTACTS')
	BEGIN
		INSERT INTO Permissions
		(Code, Name, ModuleId) VALUES ('MOBILE-SECURE-MESSAGING-INVITE-CONTACTS', 'Function - Mobile Secure Messaging Invite Contacts', 3)
	END
	/* #000 */
	
	/* Start #734 JOBACTIVITY In AdminConsole */
	-- INSERT RECORD INTO MODULES TABLE 
	IF NOT EXISTS (SELECT 1 FROM Modules WHERE ApplicationId = 5 and ModuleCode = 'ADMIN_CONSOLE_CENTRALIZED_JOB_ACTIVITY_DASHBOARD')
	BEGIN
		SET IDENTITY_INSERT [dbo].[Modules] ON
		INSERT INTO dbo.Modules(ModuleId, ApplicationId , ModuleName ,IsDeleted ,DateCreated ,DateUpdated,ModuleCode )
				VALUES  ( 33, --ModuleId - int
						   5 , -- ApplicationId - int
						  'Centralized Job Activity Dashboard' , -- ModuleName - varchar(100)
						  0 , -- IsDeleted - bit
						  GETDATE() , -- DateCreated - datetime
						  GETDATE(),  -- DateUpdated - datetime
						  'ADMIN_CONSOLE_CENTRALIZED_JOB_ACTIVITY_DASHBOARD'
						)
		SET IDENTITY_INSERT [dbo].[Modules] OFF
	END

	------------------------------------
	-- INSERT RECORD INTO PERMISSIONS TABLE 
	------------------------------------

	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'TAB-JOBACTIVITY')
	BEGIN
		INSERT INTO dbo.Permissions( Code , Name , ParentPermissionID , ModuleId) values('TAB-JOBACTIVITY','Centralized Job Activity Dashboard',NULL,33)
	END

	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBACTIVITY-RESET-SINGLE-JOB')
	BEGIN
		INSERT INTO dbo.Permissions( Code , Name , ParentPermissionID , ModuleId) values('FNC-JOBACTIVITY-RESET-SINGLE-JOB','Function - Reset Single job for reprocess',NULL,33)
	END

	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBACTIVITY-VIEW-ERROR-JOB')
	BEGIN
		INSERT INTO dbo.Permissions( Code , Name , ParentPermissionID , ModuleId) values('FNC-JOBACTIVITY-VIEW-ERROR-JOB','Function - View Error Jobs' ,NULL,33)
	END

	IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Code = 'FNC-JOBACTIVITY-RESET-ALL-JOBS')
	BEGIN
		INSERT INTO dbo.Permissions( Code , Name , ParentPermissionID , ModuleId) values('FNC-JOBACTIVITY-RESET-ALL-JOBS','Function - Reset all jobs for reprocess' ,NULL,33)
	END

	/* End #734 JOBACTIVITY In AdminConsole */

	

END

GO
