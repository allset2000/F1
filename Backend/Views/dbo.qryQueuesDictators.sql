SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueuesDictators]
AS
SELECT     dbo.Queue_Names.QueueName, dbo.Dictators.FirstName + ' ' + dbo.Dictators.LastName AS FullName, dbo.Queue_Names.QueueID, dbo.Dictators.DictatorID
FROM         dbo.Dictators INNER JOIN
                      dbo.Queue_Dictators ON dbo.Dictators.DictatorID = dbo.Queue_Dictators.DictatorID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Dictators.Queue_ID = dbo.Queue_Names.QueueID
GO
