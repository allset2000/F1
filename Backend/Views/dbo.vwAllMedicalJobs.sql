SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwAllMedicalJobs]
AS
SELECT     dbo.Jobs.JobId, dbo.Jobs.JobNumber, dbo.Jobs.JobType, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.Location, dbo.Jobs.DictatorID, 
                      dbo.Dictators.DictatorIdOk, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, ISNULL(dbo.Jobs.AppointmentDate, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) 
                      AS AppointmentDate, ISNULL(dbo.Jobs.AppointmentTime, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) AS AppointmentTime, ISNULL(dbo.Jobs.Duration, 0) 
                      AS Duration, ISNULL(dbo.Jobs.ReceivedOn, CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS ReceivedOn, dbo.Jobs.DueDate, ISNULL(dbo.Jobs.CompletedOn, 
                      CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS CompletedOn, ISNULL(dbo.Jobs.CC, 0) AS CC, dbo.Jobs.GenericPatientFlag, dbo.Jobs.Stat, 
                      ISNULL(dbo.Jobs.EditorID, '') AS EditorID, ISNULL(dbo.Editors.FirstName, '') + ' ' + ISNULL(dbo.Editors.LastName, '') AS EditorFullName, 
                      ISNULL(dbo.Jobs.DocumentStatus, 0) AS DocumentStatus, ISNULL(dbo.Jobs_Referring.FirstName, '') AS ReferringFirstName, ISNULL(dbo.Jobs_Referring.MI, '') 
                      AS ReferringMI, ISNULL(dbo.Jobs_Referring.LastName, '') AS ReferringLastName, ISNULL(dbo.Jobs_Referring.Address1, '') AS ReferringAddress1, 
                      ISNULL(dbo.Jobs_Referring.Address2, '') AS ReferringAddress2, ISNULL(dbo.Jobs_Referring.City, '') AS ReferringCity, ISNULL(dbo.Jobs_Referring.State, '') 
                      AS ReferringState, ISNULL(dbo.Jobs_Referring.Zip, '') AS ReferringZip, dbo.vwPatients.PatientAlternateID, dbo.vwPatients.MRN, dbo.vwPatients.PatientName, 
                      dbo.vwPatients.PatientFirstName, dbo.vwPatients.PatientMI, dbo.vwPatients.PatientLastName, dbo.vwPatients.PatientSuffix, dbo.vwPatients.PatientDOB, 
                      dbo.vwPatients.PatientSSN, dbo.vwPatients.PatientAddress1, dbo.vwPatients.PatientAddress2, dbo.vwPatients.PatientCity, dbo.vwPatients.PatientState, 
                      dbo.vwPatients.PatientZip, dbo.vwPatients.PatientPhone, dbo.vwPatients.PatientSex, ISNULL(dbo.Jobs_Client.FileName, '') AS CustomerJobNumber, 
                      dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, 
                      dbo.JobEditingSummary.LastQAEditorID, dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.FinishedOn, 
                      dbo.JobEditingSummary.LastQANote, dbo.JobEditingSummary.QAEditorsList
FROM         dbo.Jobs_Referring INNER JOIN
                      dbo.Jobs INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID ON dbo.Jobs_Referring.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber LEFT OUTER JOIN
                      dbo.Editors ON dbo.Jobs.EditorID = dbo.Editors.EditorID
GO
