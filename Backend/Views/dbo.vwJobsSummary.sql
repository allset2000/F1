SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwJobsSummary]
AS
SELECT     JobNumber, DictatorID, ClinicID, ClinicName, Location, TemplatesFolder, AppointmentDate, AppointmentTime, JobType, ContextName, Vocabulary, Stat, CC, Duration, 
                      DictationDate, DictationTime, ReceivedOn, ReturnedOn, CompletedOn, RecServer, EditorID, BilledOn, Amount, ParentJobNumber, DocumentStatus, VREnabled, 
                      JobStatus, StatusClass, OldStatusStage AS StatusStage, JobStatusDate, JobStatusName, SpeechFolderTag, SpeechDataFolder, FirstName, MI, LastName, Suffix, 
                      Initials, Signature, User_Code, DictatorFirstName, DictatorMI, DictatorLastName, ReferringFirstName, ReferringMI, ReferringLastName, ReferringAddress1, 
                      ReferringAddress2, ReferringCity, ReferringState, ReferringZip, MRN, PatientName, PatientFirstName, PatientMI, PatientLastName, PatientSuffix, PatientDOB, 
                      PatientSSN, PatientAddress1, PatientAddress2, PatientCity, PatientState, PatientZip, PatientPhone, PatientSex, PatientAlternateID, CASE WHEN DATEDIFF(minute, 
                      ReceivedOn, GETDATE()) <= 60 AND Stat = 1 THEN 1 ELSE 0 END AS Less_OneHour, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 60 AND 
                      Stat = 1 THEN 1 ELSE 0 END AS Great_OneHour, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 360 AND Stat = 0 THEN 1 ELSE 0 END AS Less_SixHours,
                       CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 720) AND 
                      Stat = 0 THEN 1 ELSE 0 END AS Great_SixHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, ReceivedOn, GETDATE()) 
                      <= 1080) AND Stat = 0 THEN 1 ELSE 0 END AS Great_TwelveHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, 
                      ReceivedOn, GETDATE()) <= 1440) AND Stat = 0 THEN 1 ELSE 0 END AS Great_EighteenHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 1440 AND 
                      DATEDIFF(minute, ReceivedOn, GETDATE()) <= 2880) AND Stat = 0 THEN 1 ELSE 0 END AS Great_TwentyFourHours, CASE WHEN DATEDIFF(minute, ReceivedOn, 
                      GETDATE()) > 2880 AND Stat = 0 THEN 1 ELSE 0 END AS Great_FortyEightHours, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 60 AND 
                      Stat = 1 THEN 7 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 60 AND Stat = 1 THEN 8 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 360 AND 
                      Stat = 0 THEN 1 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 720 AND 
                      Stat = 0 THEN 2 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 1080 AND 
                      Stat = 0 THEN 3 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 1440 AND 
                      Stat = 0 THEN 4 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 1440 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 2880 AND 
                      Stat = 0 THEN 5 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 2880 AND Stat = 0 THEN 6 END AS Dashboard_Id
FROM         dbo.vwMedicalJobs
WHERE     (JobStatus < 240)
GO
