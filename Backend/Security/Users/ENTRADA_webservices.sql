IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADA\webservices')
CREATE LOGIN [ENTRADA\webservices] FROM WINDOWS
GO
CREATE USER [ENTRADA\webservices] FOR LOGIN [ENTRADA\webservices]
GO
