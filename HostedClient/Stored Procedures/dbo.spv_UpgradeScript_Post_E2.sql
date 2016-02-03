
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
	/*5478*/
END

GO
