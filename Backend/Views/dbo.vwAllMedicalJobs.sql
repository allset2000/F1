SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwAllMedicalJobs]
AS
SELECT     dbo.Jobs.JobId, dbo.Jobs.JobNumber, dbo.Jobs.JobType, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.Location, dbo.Jobs.DictatorID, 
                      dbo.Dictators.DictatorIdOk, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, ISNULL(dbo.Jobs.AppointmentDate, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) 
                      AS AppointmentDate, ISNULL(dbo.Jobs.AppointmentTime, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) AS AppointmentTime, dbo.Jobs.Duration, 
                      ISNULL(dbo.Jobs.ReceivedOn, CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS ReceivedOn, dbo.Jobs.DueDate, ISNULL(dbo.Jobs.CompletedOn, 
                      CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS CompletedOn, dbo.Jobs.CC, dbo.Jobs.GenericPatientFlag, dbo.Jobs.Stat, ISNULL(dbo.Jobs.EditorID, '') 
                      AS EditorID, ISNULL(dbo.Editors.FirstName, '') + ' ' + ISNULL(dbo.Editors.LastName, '') AS EditorFullName, ISNULL(dbo.Jobs.DocumentStatus, 0) AS DocumentStatus, 
                      dbo.Jobs_Referring.FirstName AS ReferringFirstName, dbo.Jobs_Referring.MI AS ReferringMI, dbo.Jobs_Referring.LastName AS ReferringLastName, 
                      dbo.Jobs_Referring.Address1 AS ReferringAddress1, dbo.Jobs_Referring.Address2 AS ReferringAddress2, dbo.Jobs_Referring.City AS ReferringCity, 
                      dbo.Jobs_Referring.State AS ReferringState, dbo.Jobs_Referring.Zip AS ReferringZip, dbo.Jobs_Patients.AlternateID AS PatientAlternateID, dbo.Jobs_Patients.MRN, 
                      dbo.Jobs_Patients.LastName + ', ' + dbo.Jobs_Patients.FirstName AS PatientName, dbo.Jobs_Patients.FirstName AS PatientFirstName, 
                      dbo.Jobs_Patients.MI AS PatientMI, dbo.Jobs_Patients.LastName AS PatientLastName, dbo.Jobs_Patients.Suffix AS PatientSuffix, ISNULL(dbo.Jobs_Patients.DOB, '') 
                      AS PatientDOB, dbo.Jobs_Patients.SSN AS PatientSSN, dbo.Jobs_Patients.Address1 AS PatientAddress1, dbo.Jobs_Patients.Address2 AS PatientAddress2, 
                      dbo.Jobs_Patients.City AS PatientCity, dbo.Jobs_Patients.State AS PatientState, dbo.Jobs_Patients.Zip AS PatientZip, dbo.Jobs_Patients.Phone AS PatientPhone, 
                      ISNULL(dbo.Jobs_Patients.Sex, 'U') AS PatientSex, dbo.Jobs_Client.FileName AS CustomerJobNumber, dbo.JobEditingSummary.AssignedToID, 
                      dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, dbo.JobEditingSummary.LastQAEditorID, 
                      dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.FinishedOn, dbo.JobEditingSummary.LastQANote, 
                      dbo.JobEditingSummary.QAEditorsList, dbo.Jobs.IsGenericJob
FROM         dbo.Jobs_Referring INNER JOIN
                      dbo.Jobs INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID ON dbo.Jobs_Referring.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber LEFT OUTER JOIN
                      dbo.Editors ON dbo.Jobs.EditorID = dbo.Editors.EditorID
GO
