SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[qryROWJobList]
AS
SELECT     dbo.Jobs.JobNumber, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, dbo.Jobs.Location, dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, 
                      dbo.Jobs.Vocabulary, dbo.Jobs.Stat, dbo.Jobs.CC, dbo.Jobs.Duration, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, dbo.Jobs.ReceivedOn, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, 
                      dbo.Jobs.RecServer, dbo.Jobs.EditorID, dbo.Jobs.BilledOn, dbo.Jobs.Amount, dbo.Jobs.ParentJobNumber, dbo.Jobs.DocumentStatus, dbo.Jobs.AppointmentId, dbo.Jobs.DocumentId, 
                      dbo.Jobs.JobId, dbo.Jobs.JobStatus, dbo.Jobs.JobStatusDate, dbo.Jobs.JobPath, dbo.Jobs.GenericPatientFlag, dbo.Jobs.PoorAudioFlag, dbo.Jobs.TranscriptionModeFlag, 
                      dbo.Jobs.JobEditingSummaryId, dbo.Jobs_Patients.AlternateID, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, dbo.Jobs_Patients.MI, dbo.Jobs_Patients.LastName, 
                      dbo.Jobs_Patients.Suffix, dbo.Jobs_Patients.DOB, dbo.Jobs_Patients.SSN, dbo.Jobs_Patients.Address1, dbo.Jobs_Patients.Address2, dbo.Jobs_Patients.City, dbo.Jobs_Patients.State, 
                      dbo.Jobs_Patients.Zip, dbo.Jobs_Patients.Phone, dbo.Jobs_Patients.Sex, dbo.Jobs_Patients.PatientId, dbo.Jobs_Patients.AppointmentId AS PatAppointmentId, dbo.Jobs_Custom.Custom1, 
                      dbo.Jobs_Custom.Custom2, dbo.Jobs_Custom.Custom3, dbo.Jobs_Custom.Custom4, dbo.Jobs_Custom.Custom5, dbo.Jobs_Custom.Custom6, dbo.Jobs_Custom.Custom7, 
                      dbo.Jobs_Custom.Custom8, dbo.Jobs_Custom.Custom9, dbo.Jobs_Custom.Custom10, dbo.Jobs_Custom.Custom11, dbo.Jobs_Custom.Custom12, dbo.Jobs_Custom.Custom13, 
                      dbo.Jobs_Custom.Custom14, dbo.Jobs_Custom.Custom15, dbo.Jobs_Custom.Custom16, dbo.Jobs_Custom.Custom17, dbo.Jobs_Custom.Custom18, dbo.Jobs_Custom.Custom19, 
                      dbo.Jobs_Custom.Custom20, dbo.Jobs_Custom.Custom21, dbo.Jobs_Custom.Custom22, dbo.Jobs_Custom.Custom23, dbo.Jobs_Custom.Custom24, dbo.Jobs_Custom.Custom25, 
                      dbo.Jobs_Custom.Custom26, dbo.Jobs_Custom.Custom27, dbo.Jobs_Custom.Custom28, dbo.Jobs_Custom.Custom29, dbo.Jobs_Custom.Custom30, dbo.Jobs_Custom.Custom31, 
                      dbo.Jobs_Custom.Custom32, dbo.Jobs_Custom.Custom33, dbo.Jobs_Custom.Custom34, dbo.Jobs_Custom.Custom35, dbo.Jobs_Custom.Custom36, dbo.Jobs_Custom.Custom37, 
                      dbo.Jobs_Custom.Custom38, dbo.Jobs_Custom.Custom39, dbo.Jobs_Custom.Custom40, dbo.Jobs_Custom.Custom41, dbo.Jobs_Custom.Custom42, dbo.Jobs_Custom.Custom43, 
                      dbo.Jobs_Custom.Custom44, dbo.Jobs_Custom.Custom45, dbo.Jobs_Custom.Custom46, dbo.Jobs_Custom.Custom47, dbo.Jobs_Custom.Custom48, dbo.Jobs_Custom.Custom49, 
                      dbo.Jobs_Custom.Custom50, dbo.JobsToDeliver.RuleName, JR.PhysicianID AS RefPhysicianID, JR.FirstName AS RefFirstName, JR.MI AS RefMI, JR.LastName AS RefLastName, 
                      JR.Suffix AS RefSuffix, JR.DOB AS RefDOB, JR.SSN AS RefSSN, JR.Sex AS RefSex, JR.Address1 AS RefAddress1, JR.Address2 AS RefAddress2, JR.City AS RefCity, JR.State AS RefState, 
                      JR.Zip AS RefZip, JR.Phone AS RefPhone, JR.Fax AS RefFax, JR.ClinicName AS RefClinicName, dbo.Jobs_Client.FileName AS ClientJobNumber, dbo.JobsToDeliver.DeliveryID, 
                      dbo.JobsToDeliver.Method, dbo.JobsToDeliver.LastUpdatedOn, dbo.Dictators.FirstName AS DictatorFirstName, dbo.Dictators.MI AS DictatorMI, dbo.Dictators.LastName AS DictatorLastName, 
                      dbo.Dictators.Suffix AS DictatorSuffix, dbo.Dictators.Initials AS DictatorInitials, RTRIM(dbo.Dictators.FirstName) + ' ' + RTRIM(dbo.Dictators.MI) + ' ' + RTRIM(dbo.Dictators.LastName) + ', ' + RTRIM(dbo.Dictators.Suffix) AS DictatorSignature, dbo.Dictators.User_Code AS DictatorUserCode, 
                      dbo.Dictators.EHRProviderID, dbo.Dictators.EHRAliasID, dbo.Clinics.EHRClinicID
					  , CASE WHEN (SELECT COUNT(*) FROM Job_History WHERE (MRN IS NOT NULL OR FirstName IS NOT NULL OR MI IS NOT NULL OR LastName IS NOT NULL OR DOB IS NOT NULL) AND JobNumber = Jobs_Patients.JobNumber AND IsHistory = 0) > 0 THEN 1 ELSE 0 END AS 'DemographicsUpdated'
FROM         dbo.JobsToDeliver INNER JOIN
                      dbo.Jobs ON dbo.JobsToDeliver.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
                      dbo.Jobs_Referring AS JR ON dbo.Jobs.JobNumber = JR.JobNumber INNER JOIN
                      dbo.Jobs_Custom ON dbo.Jobs.JobNumber = dbo.Jobs_Custom.JobNumber INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber



GO
