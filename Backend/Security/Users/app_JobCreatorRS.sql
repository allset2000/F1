IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'app_JobCreatorRS')
CREATE LOGIN [app_JobCreatorRS] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [app_JobCreatorRS] FOR LOGIN [app_JobCreatorRS]
GO
