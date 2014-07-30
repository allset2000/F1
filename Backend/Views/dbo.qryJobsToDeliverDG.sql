SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobsToDeliverDG]
AS
SELECT     dbo.JobsToDeliver.JobNumber, dbo.JobsToDeliver.Method, dbo.JobsToDeliver.RuleName, dbo.Clinics.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.DictatorID, 
                      dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, 
                      dbo.Jobs_Patients.LastName, dbo.Jobs_Patients.DOB, dbo.Jobs_Custom.Custom1, dbo.Jobs_Custom.Custom6, dbo.Jobs_Custom.Custom12
FROM         dbo.JobsToDeliver INNER JOIN
                      dbo.Jobs ON dbo.JobsToDeliver.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
                      dbo.Jobs_Custom ON dbo.Jobs.JobNumber = dbo.Jobs_Custom.JobNumber
GO
