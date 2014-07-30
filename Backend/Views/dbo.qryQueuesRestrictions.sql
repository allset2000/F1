SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesRestrictions]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Editors.FirstName + ' ' + dbo.Editors.LastName AS EditorName, dbo.Clinics.ClinicName, 
                      dbo.Dictators.FirstName + ' ' + dbo.Dictators.LastName AS DictatorName, dbo.Queue_Names.QueueID, dbo.Editors.EditorID, dbo.Clinics.ClinicID, 
                      dbo.Dictators.DictatorID
FROM         dbo.Queue_Restrictions LEFT OUTER JOIN
                      dbo.Editors ON dbo.Queue_Restrictions.EditorID = dbo.Editors.EditorID LEFT OUTER JOIN
                      dbo.Queue_Names ON dbo.Queue_Restrictions.QueueID = dbo.Queue_Names.QueueID LEFT OUTER JOIN
                      dbo.Dictators ON dbo.Queue_Restrictions.DictatorID = dbo.Dictators.DictatorID LEFT OUTER JOIN
                      dbo.Clinics ON dbo.Queue_Restrictions.ClinicID = dbo.Clinics.ClinicID
GO
