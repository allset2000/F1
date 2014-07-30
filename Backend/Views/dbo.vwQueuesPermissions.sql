SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwQueuesPermissions]
AS
SELECT     dbo.Queue_Dictators.Queue_ID AS QueueID, dbo.Queue_Names.QueueName, dbo.Queue_Names.Type AS QueueType, dbo.Queue_Editors.EditorID, 
                      dbo.Editors.Type AS EditorType, dbo.Queue_Editors.Priority, ISNULL(dbo.Queue_Dictators.ClinicID, 0) AS ClinicID, ISNULL(dbo.Queue_Dictators.Location, 0) 
                      AS Location, ISNULL(dbo.Queue_Dictators.DictatorID, '') AS DictatorID, ISNULL(dbo.Queue_Dictators.Filter, '') AS QueueFilter
FROM         dbo.Queue_Dictators INNER JOIN
                      dbo.Queue_Editors ON dbo.Queue_Dictators.Queue_ID = dbo.Queue_Editors.QueueID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Editors.QueueID = dbo.Queue_Names.QueueID INNER JOIN
                      dbo.Editors ON dbo.Queue_Editors.EditorID = dbo.Editors.EditorID

GO
