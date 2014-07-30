IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'carnold')
CREATE LOGIN [carnold] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [carnold] FOR LOGIN [carnold]
GO
