SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[qryJobsToDeliverErrors]
AS
SELECT     TOP (100) PERCENT dbo.JobsToDeliver.DeliveryID, dbo.JobsToDeliver.JobNumber, dbo.JobsToDeliver.Method, dbo.JobsDeliveryMethods.Description, 
                      dbo.JobsToDeliver.RuleName, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Clinics.ClinicCode, dbo.Jobs.DictatorID, dbo.Jobs.AppointmentDate, 
                      dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, dbo.Jobs_Patients.LastName, 
                      dbo.qryJobsToDeliverErrors_10.ConfigurationName, dbo.qryJobsToDeliverErrors_10.ErrorId, dbo.qryJobsToDeliverErrors_10.ErrorDate, 
                      dbo.qryJobsToDeliverErrors_10.Message, dbo.qryJobsToDeliverErrors_10.ErrorMessage, dbo.qryJobsToDeliverErrors_10.ExceptionMessage, 
                      dbo.qryJobsToDeliverErrors_10.StackTrace
FROM         dbo.Jobs INNER JOIN
                      dbo.JobsToDeliver ON dbo.Jobs.JobNumber = dbo.JobsToDeliver.JobNumber INNER JOIN
                      dbo.qryJobsToDeliverErrors_10 ON dbo.JobsToDeliver.DeliveryID = dbo.qryJobsToDeliverErrors_10.DeliveryId INNER JOIN
                      dbo.JobsDeliveryMethods ON dbo.JobsToDeliver.Method = dbo.JobsDeliveryMethods.JobDeliveryID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber
ORDER BY dbo.JobsToDeliver.DeliveryID, dbo.qryJobsToDeliverErrors_10.ErrorDate

GO
