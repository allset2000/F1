IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\atyshchenko')
CREATE LOGIN [ENTRADAHEALTH\atyshchenko] FROM WINDOWS
GO
CREATE USER [ENTRADAHEALTH\atyshchenko] FOR LOGIN [ENTRADAHEALTH\atyshchenko]
GO
