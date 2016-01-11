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


	IF NOT EXISTS(select 1 from [Permissions] where code ='MOBILE-SECURE-MESSAGING-DELETE-MESSAGE')
	BEGIN
		INSERT INTO  [dbo].[Permissions] SELECT 'MOBILE-SECURE-MESSAGING-DELETE-MESSAGE','Allows user to delete message locally from a chat', NULL,3
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


END

GO
