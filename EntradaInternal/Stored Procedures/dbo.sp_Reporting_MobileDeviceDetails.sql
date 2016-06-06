SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Procedure [dbo].[sp_Reporting_MobileDeviceDetails]

@daysBack INT = 0
AS
BEGIN

IF OBJECT_ID('tempdb..#dataHold') IS NOT NULL DROP TABLE #dataHold

Create table #dataHold 
(clinicid VARCHAR(10), 
ClinicName varchar(100), 
DictatorID varchar(25), 
DictatorName varchar(250), 
DeviceGeneral varchar(25), 
deviceSpecific varchar(60), 
os varchar(15), 
EntradaVersion varchar(65), 
ClientVersion varchar(120))

Insert into #dataHold (clinicid, ClinicName, DictatorID, DictatorName)
SELECT C.ClinicID, C.ClinicName, ND.dictatorid, D.clientuserid 
FROM entrada.dbo.Dictators D 
INNER JOIN entrada.dbo.Clinics C on C.ClinicID=D.ClinicID 
LEFT JOIN SQL003.Entradahostedclient.dbo.Dictators ND on D.ClientuserID=ND.DictatorName and D.clinicID= ND.ClinicID

UPDATE A 
set A.ClientVersion = B.ClientVersion
FROM #dataHold A
inner JOIN (
SELECT Dictations.DictatorID as DictatorID, MAX(Dictations.ClientVersion) as ClientVersion, MAX(Dictations.DictationID) as DictationID
        FROM sql003.Entradahostedclient.dbo.Dictations  WITH (NOLOCK) 
        inner join sql003.Entradahostedclient.dbo.DictationsTracking DT On Dictations.DictationID=DT.DictationID AND DT.Status=250 
        where  Dictations.Status= 250 AND DT.ChangeDate >
        CASE WHEN @daysBack = 0 THEN
        DateADD(YEAR,-100,GETDATE())ELSE DateADD(DAY,-@daysBack,GETDATE())END
        GROUP BY Dictations.DictatorID
        ) AS B ON A.DictatorID = B.DictatorID
 
UPDATE #dataHold 
SET deviceSpecific = CASE WHEN ClientVersion NOT like '%#%' and ClientVersion IS NOT NULL AND ClientVersion like '%/%'
	THEN LEFT(ClientVersion,CHARINDEX('/',Clientversion,0)-1)
	ELSE SUBSTRING(ClientVersion, CHARINDEX('on',Clientversion,0)+3,25)
	END

--UPDATE #dataHold 
--SET DeviceGeneral = CASE WHEN Clientversion like '%iPhone%' or clientversion like '%iPad%' THEN 'iOS' 
--	WHEN CLientversion NOT like '%iPhone%' or clientversion NOT like '%iPad%' and Clientversion is not null THEN 'Android' 
--	WHEN ClientVersion IS NULL THEN 'NO DICTATION'
--	ELSE 'UNKNOWN' END

UPDATE #dataHold SET DeviceGeneral = 
 CASE WHEN Clientversion like '%iPhone%' or clientversion like '%iPad%' OR clientversion like '%iPod%' THEN 'iOS' 
   WHEN CLientversion NOT like '%iPhone%' or clientversion NOT like '%iPad%' and clientversion like '%iPod%' and Clientversion is not null THEN 'Android' 
   WHEN ClientVersion IS NULL THEN 'NO DICTATION'
   ELSE 'UNKNOWN' END

UPDATE #dataHold 
SET deviceSpecific = LEFT(deviceSpecific,CharINDEX(' ',deviceSpecific,0)),
	os = REPLACE(SUBSTRING(deviceSpecific,CharINDEX(' ',deviceSpecific,0)+1,15),'OS ','')
WHERE Devicegeneral = 'iOS'

UPDATE #dataHold 
SET deviceSpecific = CASE WHEN deviceSpecific like '% OS %' THEN LEFT(deviceSpecific,CharINDEX(' OS ',deviceSpecific,0)) ELSE 'UNKNOWN' END,
	os = CASE WHEN deviceSpecific like '% OS %' THEN REPLACE(SUBSTRING(deviceSpecific,CharINDEX(' ',deviceSpecific,0)+1,15),'OS ','') ELSE 'UNKNOWN' END
WHERE Devicegeneral = 'Android'

UPDATE #dataHold 
SET EntradaVersion = CASE WHEN ClientVersion NOT LIKE '%#%' AND os !='UNKNOWN' THEN SUBSTRING(ClientVersion,CHARINDEX('Entrada Mobile',clientversion,0)+15,65) 
	WHEN ClientVersion LIKE '%#%' THEN REPLACE(SUBSTRING(Clientversion, Charindex('(', clientversion, 0)+8, 9),'#', ' Build ')	
	WHEN ClientVersion IS NULL THEN NULL ELSE '?' END

UPDATE #dataHold 
SET DeviceGeneral = 'OLD SCHEMA' 
FROM #dataHold A INNER JOIN
	(
	select D.clientuserID, D.clinicID 
	from entrada.dbo.jobs J 
	INNER JOIN entrada.dbo.Dictators D on J.DictatorID=D.DictatorID AND J.DictationDate > CASE WHEN @daysBack = 0 THEN DateADD(YEAR,-100, GETDATE()) ELSE DateADD(DAY,-@daysBack, GETDATE()) END 
	) OS ON OS.clientuserID = A.DictatorName AND OS.ClinicID = A.clinicid
WHERE DeviceGeneral = 'NO DICTATION'

select * from #dataHold 
drop table #dataHold

END

GO
