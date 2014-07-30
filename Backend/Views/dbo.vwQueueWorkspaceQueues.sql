SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwQueueWorkspaceQueues]
AS
SELECT     dbo.QueueWorkspaceQueues.*
FROM         dbo.QueueWorkspaceQueues
WHERE     (QueueWorkspaceQueueStatus = 'A')
GO
