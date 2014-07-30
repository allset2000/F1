IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'app_JobCreator')
CREATE LOGIN [app_JobCreator] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [app_JobCreator] FOR LOGIN [app_JobCreator]
GO
