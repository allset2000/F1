IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'app_JobTranscoder')
CREATE LOGIN [app_JobTranscoder] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [app_JobTranscoder] FOR LOGIN [app_JobTranscoder]
GO
