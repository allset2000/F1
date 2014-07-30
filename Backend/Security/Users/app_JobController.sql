IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'app_JobController')
CREATE LOGIN [app_JobController] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [app_JobController] FOR LOGIN [app_JobController]
GO
