IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\dev_apps')
CREATE LOGIN [ENTRADAHEALTH\dev_apps] FROM WINDOWS
GO
CREATE USER [entradahealth\dev_apps] FOR LOGIN [ENTRADAHEALTH\dev_apps]
GO
