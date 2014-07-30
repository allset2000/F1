SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryQueueNames]
AS
SELECT     TOP (100) PERCENT '<span style="display:none;">' + QueueName + '</span><a href="javascript:displayQueueData(' + CONVERT(varchar(8), QueueID) 
                      + ')">' + QueueName + '</a>' AS Queues, QueueName, QueueID
FROM         dbo.Queue_Names
GO
