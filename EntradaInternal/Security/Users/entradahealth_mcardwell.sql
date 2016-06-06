IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\mcardwell')
CREATE LOGIN [ENTRADAHEALTH\mcardwell] FROM WINDOWS
GO
CREATE USER [entradahealth\mcardwell] FOR LOGIN [ENTRADAHEALTH\mcardwell]
GO
GRANT EXECUTE TO [entradahealth\mcardwell]
