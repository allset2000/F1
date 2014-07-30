IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADA-DEV\Administrator')
CREATE LOGIN [ENTRADA-DEV\Administrator] FROM WINDOWS
GO
CREATE USER [ENTRADA-DEV\Administrator] FOR LOGIN [ENTRADA-DEV\Administrator]
GO
