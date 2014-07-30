IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'rspears')
CREATE LOGIN [rspears] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [rspears] FOR LOGIN [rspears]
GO
