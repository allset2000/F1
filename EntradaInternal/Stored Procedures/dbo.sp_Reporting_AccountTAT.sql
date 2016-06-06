SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Sindhuri Manne
Create date:	12/17/14
Description:	Implementation report that shows Account TAT
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_AccountTAT]
	
	@ClinicId varchar (250),
	@BeginDate datetime,
	@EndDate datetime,
	@DateType smallint 
	
	AS

SELECT  j.JobNumber, j.DictatorID, j.AppointmentDate, j.AppointmentTime, j.ReceivedOn, j.CompletedOn, j.ClinicID, c.ClinicName, jc.FileName, jhc.EncounterID, S.EHREncounterID
FROM Entrada.dbo.Jobs AS j 
INNER JOIN Entrada.dbo.Clinics AS c ON j.ClinicID = c.ClinicID 
INNER JOIN Entrada.dbo.Jobs_Client AS jc ON j.JobNumber = jc.JobNumber 
INNER JOIN SQL003.EntradaHostedClient.dbo.Jobs AS jhc ON jc.FileName = jhc.JobNumber
inner join SQL003.EntradaHostedClient.dbo.Encounters as E on E.EncounterID = jhc.EncounterID
inner join SQL003.EntradaHostedClient.dbo.Schedules as S on S.ScheduleID = E.ScheduleID
WHERE 
j.JobType != 'No Delivery' AND
((j.ClinicID IN (SELECT Value FROM dbo.Split(@ClinicId, ',')) AND (j.AppointmentDate BETWEEN @BeginDate AND @EndDate) AND (@DateType = 1))) OR
((j.ClinicID IN (SELECT Value FROM dbo.Split(@ClinicId, ',')) AND (j.ReceivedOn BETWEEN @BeginDate AND @EndDate) AND (@DateType = 0))) OR
((j.ClinicID IN (SELECT Value FROM dbo.Split(@ClinicId, ',')) AND (j.CompletedOn BETWEEN @BeginDate AND @EndDate) AND (@DateType = 2)))
ORDER BY j.DictatorID, j.ReceivedOn, j.CompletedOn



GO
