
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
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'EditOne', N'EditOne', 1, 1, 0, N'smukkamala@entradahealth.com', N'noreply@entradahealth.com', N'Failure at EditOne', N'smtp.entrada-dev.local', 0, NULL, NULL, 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-06-19 06:40:05.480' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Job Controller', N'JOB_CONTROLLER', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Job Controller', N'smtp.entradahealth.net', 1, N'JobController.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-04-09 08:52:43.373' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ([ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Job Builder', N'JOB_BUILDER', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Job Builder service', N'smtp.entradahealth.net', 1, N'JobBuilderErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-04-09 08:52:43.373' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Job Transcoder', N'JOB_TRANSCODER', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Job Transcoder service', N'smtp.entradahealth.net', 1, N'JobTranscoderErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-04-09 08:52:43.373' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Row Backend DataService', N'ROW_BACKEND_DATASERVICE', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Row Backend DataService', N'smtp.entradahealth.net', 1, N'RowBackendDataServiceErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-04-09 08:52:43.373' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Row Web Service', N'ROW_WEBSERVICE', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Row Web Service', N'smtp.entradahealth.net', 1, N'RowWebServiceErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-04-09 08:52:43.373' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Mobile Dictate Public WEB API', N'DICTATE_PUBLIC_API', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Mobile Dictate Public WEB API', N'smtp.entradahealth.net', 1, N'MobileDictatePubliclWebApiErrorLog.txt', N'C:\EntradaLogs\', 1, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-06-17 13:21:23.817' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Real Time TCP IP Server', N'REAL_TIME_TCP_IP_SERVER', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Real Time TCP IP Server', N'smtp.entradahealth.net', 1, N'RealTimeTcpIpServerErrorLog.txt', N'C:\EntradaLogs\', 1, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-06-24 07:56:34.240' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Customer Portal UI', N'CUSTOMER_PORTAL_UI', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Customer Portal UI', N'smtp.entradahealth.net', 1, N'CustomerPortalUIErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-07-10 03:49:07.340' AS DateTime), NULL)
INSERT [dbo].[LogConfiguration] ( [ApplicationName], [ApplicationCode], [IsActive], [DatabaseEnabled], [EmailEnabled], [EmailTo], [EmailFrom], [EmailSubject], [EmailSMTP], [FileEnabled], [LogFileName], [LogFilePath], [EventLogEnabled], [IsPublicApp], [PublicAppApiBaseUri], [PublicAppApiUri], [IsPublicWeb], [PublicWebApiBaseUri], [PublicWebApiUri], [CreatedDate], [UpdatedDate]) VALUES ( N'Customer Portal Services', N'CUSTOMER_PORTAL_SERVICE', 1, 1, 0, NULL, N'noreply@entradahealth.com', N'Failure at Customer Portal Web API Services', N'smtp.entradahealth.net', 1, N'CustomerPortalServicesErrorLog.txt', N'C:\EntradaLogs\', 0, 0, NULL, NULL, 0, NULL, NULL, CAST(N'2015-07-10 03:49:07.340' AS DateTime), NULL)
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


-- #3930 part b# - Adding centrilized logger to Real Time TCP IP server
IF NOT EXISTS (SELECT 1 FROM dbo.LogConfiguration WHERE ApplicationCode = 'REAL_TIME_TCP_IP_SERVER') BEGIN
	INSERT INTO dbo.LogConfiguration (ApplicationName, ApplicationCode, IsActive, DatabaseEnabled, EmailEnabled, EmailTo, EmailFrom, EmailSubject, EmailSMTP, FileEnabled, LogFileName, LogFilePath, EventLogEnabled, IsPublicApp, PublicAppApiBaseUri, PublicAppApiUri, IsPublicWeb, PublicWebApiBaseUri, PublicWebApiUri, CreatedDate, UpdatedDate)	  
    VALUES ('Real Time TCP IP Server','REAL_TIME_TCP_IP_SERVER',1, 1, 0, NULL, 'noreply@entradahealth.com',	'Failure at Real Time TCP IP Server',	'smtp.entradahealth.net', 1, 'RealTimeTcpIpServerErrorLog.txt', 'C:\EntradaLogs\',  1, 0, NULL, NULL, 0,	NULL, NULL,	GETDATE(),	NULL)
	PRINT 'ADDED LOG CONFIGURATION FOR Real Time TCP IP Server'
END

-- #3930# - End of adds
END

GO
