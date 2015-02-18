SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwMedicalJobsForDashBoard]
AS
SELECT     dbo.Jobs.JobNumber, dbo.Jobs.JobId, dbo.Jobs.DictatorID, dbo.Dictators.DictatorIdOk, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.Location, 
                      dbo.Dictators.TemplatesFolder, dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs.Vocabulary, 
                      dbo.Jobs.Stat, dbo.Jobs.CC, dbo.Jobs.GenericPatientFlag, dbo.Jobs.Duration, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, dbo.Jobs.ReceivedOn, 
                      dbo.Jobs.DueDate, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, dbo.Jobs.RecServer, dbo.Jobs.BilledOn, dbo.Jobs.Amount, dbo.Jobs.ParentJobNumber, 
                      dbo.Jobs_Client.FileName AS CustomerJobNumber, dbo.Jobs.DocumentStatus, ISNULL(dbo.Dictators.VREnabled, 0) AS VREnabled, ISNULL(dbo.Dictators.FirstName, 
                      '') AS FirstName, ISNULL(dbo.Dictators.MI, '') AS MI, ISNULL(dbo.Dictators.LastName, '') AS LastName, ISNULL(dbo.Dictators.Suffix, '') AS Suffix, 
                      ISNULL(dbo.Dictators.Initials, '') AS Initials, ISNULL(dbo.Dictators.Signature, '') AS Signature, ISNULL(dbo.Dictators.User_Code, '') AS User_Code, 
                      dbo.Dictators.FirstName AS DictatorFirstName, ISNULL(dbo.Dictators.MI, '') AS DictatorMI, dbo.Dictators.LastName AS DictatorLastName, 
                      dbo.Jobs_Referring.FirstName AS ReferringFirstName, dbo.Jobs_Referring.MI AS ReferringMI, dbo.Jobs_Referring.LastName AS ReferringLastName, 
                      dbo.Jobs_Referring.Address1 AS ReferringAddress1, dbo.Jobs_Referring.Address2 AS ReferringAddress2, dbo.Jobs_Referring.City AS ReferringCity, 
                      dbo.Jobs_Referring.State AS ReferringState, dbo.Jobs_Referring.Zip AS ReferringZip, dbo.vwPatients.MRN, dbo.vwPatients.PatientName, 
                      dbo.vwPatients.PatientFirstName, dbo.vwPatients.PatientMI, dbo.vwPatients.PatientLastName, dbo.vwPatients.PatientSuffix, dbo.vwPatients.PatientDOB, 
                      dbo.vwPatients.PatientSSN, dbo.vwPatients.PatientAddress1, dbo.vwPatients.PatientAddress2, dbo.vwPatients.PatientCity, dbo.vwPatients.PatientState, 
                      dbo.vwPatients.PatientZip, dbo.vwPatients.PatientPhone, dbo.vwPatients.PatientSex, dbo.vwPatients.PatientAlternateID, dbo.vwJobsStatusA.SpeechFolderTag, 
                      dbo.vwJobsStatusA.Path AS SpeechDataFolder, dbo.vwJobsStatusA.Status AS JobStatus, dbo.vwJobsStatusA.StatusClass, 
                      CASE WHEN CurrentQAStage = 'QA4' THEN 'QA2' WHEN CurrentQAStage = 'QA3' THEN 'INVALID_STATE' WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE vwJobsStatusA.StatusStage
                       END AS OldStatusStage, dbo.vwJobsStatusA.StatusDate AS JobStatusDate, dbo.vwJobsStatusA.StatusName AS JobStatusName, 
                      dbo.vwJobsStatusA.FriendlyStatusName AS JobFriendlyStatusName, dbo.vwJobsStatusA.EditionStage, dbo.Jobs.EditorID, ISNULL(dbo.vwEditors.EditorCompanyId, - 1)
                       AS EditorCompanyId, ISNULL(dbo.vwEditors.EditorCompanyCode, '') AS EditorCompanyCode, ISNULL(dbo.vwEditors.EditingWorkflowModelId, - 1) 
                      AS EditingWorkflowModelId, dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, dbo.JobEditingSummary.LastQAEditorID, 
                      dbo.JobEditingSummary.CurrentStateId, CASE WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE EditionStage END AS CurrentEditingStage, 
                      dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.QACategoryId, 
                      dbo.JobEditingSummary.LastQANote, dbo.JobEditingSummary.QAEditorsList, dbo.JobEditingSummary.FinishedOn, dbo.JobEditingSummary.LastEditingTaskId, 
                      dbo.JobEditingSummary.LastQAEditingTaskId, dbo.vwQACategories.QACategory, vwQACategories_1.QACategory AS QAParentCategory, dbo.Jobs.TemplateName, 
                      dbo.Jobs.IsGenericJob, dbo.Jobs.JobStatus AS Status
FROM         dbo.Dictators INNER JOIN
                      dbo.Jobs ON dbo.Dictators.DictatorID = dbo.Jobs.DictatorID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.vwJobsStatusA ON dbo.Jobs.JobNumber = dbo.vwJobsStatusA.JobNumber INNER JOIN
                      dbo.Jobs_Referring ON dbo.Jobs.JobNumber = dbo.Jobs_Referring.JobNumber INNER JOIN
                      dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.vwQACategories ON dbo.JobEditingSummary.QACategoryId = dbo.vwQACategories.QACategoryId INNER JOIN
                      dbo.vwQACategories AS vwQACategories_1 ON dbo.vwQACategories.ParentId = vwQACategories_1.QACategoryId LEFT OUTER JOIN
                      dbo.vwEditors ON dbo.Jobs.EditorID = dbo.vwEditors.EditorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber

GO
