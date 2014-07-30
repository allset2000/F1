IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ezobel')
CREATE LOGIN [ezobel] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [ezobel] FOR LOGIN [ezobel]
GO
