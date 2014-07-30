SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobDeliveryHistoryView]
AS
SELECT     TOP (100) PERCENT dbo.JobDeliveryHistory.DeliveryID, dbo.JobDeliveryHistory.JobNumber, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.DictatorID, 
                      dbo.JobDeliveryHistory.Method, dbo.JobDeliveryHistory.RuleName, dbo.JobDeliveryHistory.DeliveredOn, dbo.JobDeliveryHistory.JobData
FROM         dbo.JobDeliveryHistory INNER JOIN
                      dbo.Jobs ON dbo.JobDeliveryHistory.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID
ORDER BY dbo.JobDeliveryHistory.DeliveredOn
GO
