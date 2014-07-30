SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesRestrictionsOnClinics]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Clinics.ClinicName, dbo.Editors.FirstName + ' ' + dbo.Editors.LastName AS EditorName, 
                      dbo.Queue_Names.QueueID, dbo.Clinics.ClinicID, dbo.Editors.EditorID
FROM         dbo.Queue_Restrictions INNER JOIN
                      dbo.Editors ON dbo.Queue_Restrictions.EditorID = dbo.Editors.EditorID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Restrictions.QueueID = dbo.Queue_Names.QueueID INNER JOIN
                      dbo.Clinics ON dbo.Queue_Restrictions.ClinicID = dbo.Clinics.ClinicID
GO
