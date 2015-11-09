SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_GetHostedACKJobDetails]
AS
SELECT        cJ.JobNumber AS 'ClientJobNumber', cS.EHREncounterID, cJ.JobNumber, cJ.ClinicID, JP.AlternateID, JP.MRN, JP.FirstName, JP.MI, JP.LastName, JP.Suffix, JP.DOB, 
                         CONVERT(varchar(8), CAST(JP.DOB AS DATETIME), 112) AS HL7DOB, JP.Address1, JP.Address2, JP.City, JP.State, JP.Zip, JP.Gender, JP.PatientID, cS.AppointmentID,
                          C.EHRClinicID, C.ClinicCode, cP.Signature, cP.LastName AS ProviderLastName, cP.FirstName AS ProviderFirstName, cP.MI AS ProviderMI, cP.EHRProviderID, 
                         cP.EHRProviderAlias
FROM            dbo.Jobs AS cJ INNER JOIN
                         dbo.Clinics AS C ON C.ClinicID = cJ.ClinicID INNER JOIN
                         dbo.Encounters AS cE ON cE.EncounterID = cJ.EncounterID INNER JOIN
                         dbo.Schedules AS cS ON cS.ScheduleID = cE.ScheduleID INNER JOIN
                         dbo.Patients AS JP ON JP.PatientID = cS.PatientID INNER JOIN
                         dbo.Dictations AS cD ON cD.JobID = cJ.JobID INNER JOIN
                         dbo.Dictators AS cP ON cP.DictatorID = cD.DictatorID

GO