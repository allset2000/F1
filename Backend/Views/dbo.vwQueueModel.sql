SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwQueueModel]
AS
SELECT     dbo.QueueWorkspaces.QueueWorkspaceId, dbo.QueueWorkspaces.QueueWorkspaceName, dbo.QueueWorkspaces.QueueWorkspacePriorityType, 
                      dbo.Queues.QueueId, dbo.Queues.QueueName, dbo.vwQueueWorkspaceQueues.QueuePriority, ISNULL(dbo.vwQueueMembers.QueueMemberId, - 1) 
                      AS QueueMemberId, ISNULL(dbo.vwQueueMembers.ClinicId, - 1) AS ClinicId, ISNULL(dbo.vwQueueMembers.DictatorId, - 1) AS DictatorId, 
                      ISNULL(dbo.vwQueueMembers.JobsFilter, '') AS JobsFilter, ISNULL(dbo.vwEditors.EditorIdOk, - 1) AS EditorIdOk, ISNULL(dbo.vwEditors.EditorID, '') AS EditorID, 
                      ISNULL(dbo.vwEditors.EditorType, 'Editor') AS EditorType, ISNULL(dbo.vwEditors.EditorStatus, 'I') AS EditorStatus
FROM         dbo.vwQueueMembers RIGHT OUTER JOIN
                      dbo.QueueWorkspaces INNER JOIN
                      dbo.Queues INNER JOIN
                      dbo.vwQueueWorkspaceQueues ON dbo.Queues.QueueId = dbo.vwQueueWorkspaceQueues.QueueId ON 
                      dbo.QueueWorkspaces.QueueWorkspaceId = dbo.vwQueueWorkspaceQueues.QueueWorkspaceId LEFT OUTER JOIN
                      dbo.vwQueueWorkspaceEditors INNER JOIN
                      dbo.vwEditors ON dbo.vwQueueWorkspaceEditors.EditorId = dbo.vwEditors.EditorIdOk ON 
                      dbo.QueueWorkspaces.QueueWorkspaceId = dbo.vwQueueWorkspaceEditors.QueueWorkspaceId ON dbo.vwQueueMembers.QueueId = dbo.Queues.QueueId
WHERE     (ISNULL(dbo.QueueWorkspaces.QueueWorkspaceStatus, 'A') = 'A') AND (ISNULL(dbo.vwQueueWorkspaceEditors.QueueWorkspaceEditorStatus, 'A') = 'A') AND 
                      (ISNULL(dbo.vwQueueMembers.QueueMemberStatus, 'A') = 'A') AND (ISNULL(dbo.vwQueueWorkspaceQueues.QueueWorkspaceQueueStatus, 'A') = 'A') AND 
                      (dbo.Queues.QueueStatus = 'A')


UNION


SELECT     - 1 AS [QueueWorkspaceId], '' AS [QueueWorkspaceName], 'TAT' AS [QueueWorkspacePriorityType], Queues.QueueId, [QueueName], - 1 AS [QueuePriority], 
                      [QueueMemberId], [ClinicId], [DictatorId], [JobsFilter], - 1 AS EditorIdOk, '' AS [EditorID], 'Editor' AS [EditorType], 'I' AS [EditorStatus]
FROM         dbo.Queues JOIN
                      dbo.QueueMembers ON dbo.Queues.QueueId = dbo.QueueMembers.QueueId
WHERE     dbo.Queues.QueueId NOT IN
                          (SELECT     QueueId
                            FROM          QueueWorkspaceQueues
                            WHERE      QueueWorkspaceQueueStatus = 'A') AND dbo.Queues.QueueStatus = 'A' AND dbo.QueueMembers.QueueMemberStatus = 'A'


UNION

SELECT     dbo.QueueWorkspaces.QueueWorkspaceId, dbo.QueueWorkspaces.QueueWorkspaceName, dbo.QueueWorkspaces.QueueWorkspacePriorityType, - 1 AS QueueId, 
                      '' AS QueueName, - 1 AS QueuePriority, - 1 AS QueueMemberId, - 1 AS ClinicId, - 1 AS DictatorId, '' AS JobsFilter, dbo.Editors.EditorIdOk, dbo.Editors.EditorID, 
                      'Editor' AS EditorType, 'I' AS EditorStatus
FROM         dbo.QueueWorkspaces INNER JOIN
                      dbo.vwQueueWorkspaceEditors ON dbo.QueueWorkspaces.QueueWorkspaceId = dbo.vwQueueWorkspaceEditors.QueueWorkspaceId INNER JOIN
                      dbo.Editors ON dbo.vwQueueWorkspaceEditors.EditorId = dbo.Editors.EditorIdOk
WHERE     (dbo.QueueWorkspaces.QueueWorkspaceStatus = 'A') AND (dbo.vwQueueWorkspaceEditors.QueueWorkspaceEditorStatus = 'A') AND 
                      (NOT (dbo.QueueWorkspaces.QueueWorkspaceId IN
                          (SELECT     QueueWorkspaceId
                            FROM          dbo.vwQueueWorkspaceQueues)))
GO
