SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwAllMedicalJobs2]
AS


SELECT  
-- Jobs --
            dbo.Jobs.JobId, dbo.Jobs.JobNumber, dbo.Jobs.JobType, dbo.Jobs.ClinicID, dbo.Jobs.Location, dbo.Jobs.DictatorID,dbo.Jobs.DictationDate, dbo.Jobs.DictationTime,
            dbo.Jobs.AppointmentDate,
            dbo.Jobs.AppointmentTime,
            dbo.Jobs.Duration, 
            dbo.Jobs.ReceivedOn,
            dbo.Jobs.DueDate,
            dbo.Jobs.CompletedOn, 
            dbo.Jobs.CC, 
            dbo.Jobs.GenericPatientFlag, 
            dbo.Jobs.Stat,
            dbo.Jobs.EditorID,
            dbo.Jobs.DocumentStatus, 
            dbo.Jobs.IsGenericJob,

-- Clinics--
            dbo.Clinics.ClinicName, 
             
-- Dictators --
        dbo.Dictators.DictatorIdOk, 
        
-- Editors --
            dbo.Editors.FirstName + ' ' + dbo.Editors.LastName AS EditorFullName, 

-- Jobs_Referring -- 
        dbo.Jobs_Referring.FirstName AS ReferringFirstName, 
        dbo.Jobs_Referring.MI AS ReferringMI, 
        dbo.Jobs_Referring.LastName AS ReferringLastName, 
        dbo.Jobs_Referring.Address1 AS ReferringAddress1, 
        dbo.Jobs_Referring.Address2 AS ReferringAddress2, 
        dbo.Jobs_Referring.City AS ReferringCity, 
        dbo.Jobs_Referring.State AS ReferringState, 
        dbo.Jobs_Referring.Zip AS ReferringZip, 
        
-- vwPatients -- 
        dbo.vwPatients.PatientAlternateID, dbo.vwPatients.MRN, dbo.vwPatients.PatientName, dbo.vwPatients.PatientFirstName, dbo.vwPatients.PatientMI, 
        dbo.vwPatients.PatientLastName, dbo.vwPatients.PatientSuffix, dbo.vwPatients.PatientDOB, dbo.vwPatients.PatientSSN, dbo.vwPatients.PatientAddress1, 
        dbo.vwPatients.PatientAddress2, dbo.vwPatients.PatientCity, dbo.vwPatients.PatientState, dbo.vwPatients.PatientZip, dbo.vwPatients.PatientPhone, 
        dbo.vwPatients.PatientSex, 
        
-- Jobs_Client -- 
        dbo.Jobs_Client.FileName AS CustomerJobNumber, 

-- JobsEditingSummary
        dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, dbo.JobEditingSummary.LastQAEditorID, 
        dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.FinishedOn, dbo.JobEditingSummary.LastQANote, 
        dbo.JobEditingSummary.QAEditorsList
        
FROM dbo.Jobs_Referring 
                  INNER JOIN dbo.Jobs 
                  INNER JOIN dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID ON dbo.Jobs_Referring.JobNumber = dbo.Jobs.JobNumber 
                  INNER JOIN dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber 
                  INNER JOIN dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId 
                  INNER JOIN dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID 
                  LEFT OUTER JOIN dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber 
                  LEFT OUTER JOIN dbo.Editors ON dbo.Jobs.EditorID = dbo.Editors.EditorID
                  

GO
