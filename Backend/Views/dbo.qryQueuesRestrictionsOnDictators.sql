SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesRestrictionsOnDictators]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Dictators.FirstName + ' ' + dbo.Dictators.LastName AS DictatorName, 
                      dbo.Editors.FirstName + ' ' + dbo.Editors.LastName AS EditorName, dbo.Queue_Names.QueueID, dbo.Dictators.DictatorID, dbo.Editors.EditorID
FROM         dbo.Dictators INNER JOIN
                      dbo.Queue_Restrictions ON dbo.Dictators.DictatorID = dbo.Queue_Restrictions.DictatorID INNER JOIN
                      dbo.Editors ON dbo.Queue_Restrictions.EditorID = dbo.Editors.EditorID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Restrictions.QueueID = dbo.Queue_Names.QueueID
GO
