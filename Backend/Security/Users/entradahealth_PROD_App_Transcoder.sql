IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\PROD_App_Transcoder')
CREATE LOGIN [ENTRADAHEALTH\PROD_App_Transcoder] FROM WINDOWS
GO
CREATE USER [entradahealth\PROD_App_Transcoder] FOR LOGIN [ENTRADAHEALTH\PROD_App_Transcoder]
GO
GRANT EXECUTE TO [entradahealth\PROD_App_Transcoder]
