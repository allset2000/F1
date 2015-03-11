SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

/* =======================================================
Author:                    Sindhuri Manne
Create date: 2/23/2015
Description: Used to mimic "Dictate Viewer" to help legacy clients run these reports as they will not be able to use after migrating to new schema
======================================================= */

CREATE PROCEDURE [dbo].[sp_Reporting_Account_DictateViewer]

       @ReceivedOn datetime, 
       @ReceivedOn2 datetime,
       @PayTypeVar varchar(100) 

AS

SELECT J.JobNumber, J.JobID, J.ClinicID, J.Status AS JobStatus, E.AppointmentDate, P.MRN, P.FirstName, P.LastName, C.ClinicCode, C.Name AS ClinicName, 
JTP.Name AS JobName, Di.DictatorName, MAX(JT.ChangeDate) AS DeletedOn, JT.ChangedBy
FROM EntradaHostedClient.dbo.Jobs AS J 
INNER JOIN EntradaHostedClient.dbo.Encounters AS E ON J.EncounterID = E.EncounterID 
INNER JOIN EntradaHostedClient.dbo.Patients AS P ON E.PatientID = P.PatientID 
INNER JOIN EntradaHostedClient.dbo.JobTypes AS JTP ON J.JobTypeID = JTP.JobTypeID 
INNER JOIN EntradaHostedClient.dbo.Dictators AS Di ON J.OwnerDictatorID = Di.DictatorID 
INNER JOIN EntradaHostedClient.dbo.JobsTracking AS JT ON JT.JobID = J.JobID 
INNER JOIN EntradaHostedClient.dbo.Clinics AS C ON C.ClinicID = J.ClinicID
WHERE (C.ClinicCode = @PayTypeVar) AND (E.AppointmentDate BETWEEN @ReceivedOn AND @ReceivedOn2)
GROUP BY Di.DictatorName, J.JobNumber, J.JobID, J.ClinicID, J.Status, E.AppointmentDate, P.MRN, P.FirstName, P.LastName, C.ClinicCode, C.Name, JTP.Name, 
Di.DictatorName, JT.ChangedBy
ORDER BY Di.DictatorName, E.AppointmentDate asc


GO
