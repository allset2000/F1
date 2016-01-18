IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\PROD_App_JobControl')
CREATE LOGIN [ENTRADAHEALTH\PROD_App_JobControl] FROM WINDOWS
GO
CREATE USER [entradahealth\PROD_App_JobControl] FOR LOGIN [ENTRADAHEALTH\PROD_App_JobControl]
GO
GRANT EXECUTE TO [entradahealth\PROD_App_JobControl]
