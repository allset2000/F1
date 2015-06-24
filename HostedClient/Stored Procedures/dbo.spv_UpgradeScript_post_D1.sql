
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 4/30/2015
-- Description: SP Used to store all data changes in the D.1 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_D1]
AS
BEGIN
-- #3889# - Adding Application for centralized logging
IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'ADMIN_CONSOLE_INTERNAL_API') BEGIN
	INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)	  
    VALUES ('Admin Console Internal WEB API','ADMIN_CONSOLE_INTERNAL_API',1,1,0,'sshoultz@entradahealth.com','noreply@entradahealth.com','Failure at Admin Console Internal WEB API','smtp.entradahealth.net',1,'AdminConsoleInternalWebApiErrorLog.txt','C:\EntradaLogs\',0,0,null,null,0,null,null,GETDATE(),null)
	PRINT 'ADDED LOG CONFIGURATION FOR Entrada Admin Console'
END
-- #3889# - End of adds

-- #4414# - Adding centrilized logger to Dictate API public 
IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'DICTATE_PUBLIC_API') BEGIN
	INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)	  
    VALUES ('Mobile Dictate Public WEB API','DICTATE_PUBLIC_API',1, 1, 0, NULL, 'noreply@entradahealth.com',	'Failure at Mobile Dictate Public WEB API',	'smtp.entradahealth.net', 1, 'MobileDictatePubliclWebApiErrorLog.txt', 'C:\EntradaLogs\',  1, 0, NULL, NULL, 0,	NULL, NULL,	GETDATE(),	NULL)
	PRINT 'ADDED LOG CONFIGURATION FOR Entrada Mobile Dictate Public WEB API'
END
-- #4414# - End of adds

END

GO
