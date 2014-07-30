IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'jablumenthal')
CREATE LOGIN [jablumenthal] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [jablumenthal] FOR LOGIN [jablumenthal]
GO
