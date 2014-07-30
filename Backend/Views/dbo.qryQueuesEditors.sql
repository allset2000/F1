SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesEditors]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Editors.FirstName + ' ' + dbo.Editors.LastName AS FullName, dbo.Queue_Names.QueueID, 
                      dbo.Editors.EditorID
FROM         dbo.Queue_Editors INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Editors.QueueID = dbo.Queue_Names.QueueID INNER JOIN
                      dbo.Editors ON dbo.Queue_Editors.EditorID = dbo.Editors.EditorID
GO
