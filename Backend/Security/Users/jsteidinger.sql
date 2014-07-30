IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'jsteidinger')
CREATE LOGIN [jsteidinger] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [jsteidinger] FOR LOGIN [jsteidinger]
GO
