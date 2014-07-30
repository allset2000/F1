IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'app_DocExtract')
CREATE LOGIN [app_DocExtract] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [app_DocExtract] FOR LOGIN [app_DocExtract]
GO
