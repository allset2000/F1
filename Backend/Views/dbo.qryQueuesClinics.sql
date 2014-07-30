SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesClinics]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Clinics.ClinicName, dbo.Queue_Names.QueueID, dbo.Clinics.ClinicID
FROM         dbo.Clinics INNER JOIN
                      dbo.Queue_Dictators ON dbo.Clinics.ClinicID = dbo.Queue_Dictators.ClinicID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Dictators.Queue_ID = dbo.Queue_Names.QueueID
GO
