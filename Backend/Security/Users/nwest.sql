IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'nwest')
CREATE LOGIN [nwest] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [nwest] FOR LOGIN [nwest]
GO
