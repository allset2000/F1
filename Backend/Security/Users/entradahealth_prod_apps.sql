IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\prod_apps')
CREATE LOGIN [ENTRADAHEALTH\prod_apps] FROM WINDOWS
GO
CREATE USER [entradahealth\prod_apps] FOR LOGIN [ENTRADAHEALTH\prod_apps]
GO
GRANT EXECUTE TO [entradahealth\prod_apps]
