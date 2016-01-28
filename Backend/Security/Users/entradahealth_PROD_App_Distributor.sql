IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ENTRADAHEALTH\PROD_App_Distributor')
CREATE LOGIN [ENTRADAHEALTH\PROD_App_Distributor] FROM WINDOWS
GO
CREATE USER [entradahealth\PROD_App_Distributor] FOR LOGIN [ENTRADAHEALTH\PROD_App_Distributor]
GO
GRANT EXECUTE TO [entradahealth\PROD_App_Distributor]
