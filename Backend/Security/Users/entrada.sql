IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'entrada')
CREATE LOGIN [entrada] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [entrada] FOR LOGIN [entrada]
GO
