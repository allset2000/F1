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
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[45] 2[23] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vwQueueModel', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwQueueModel', NULL, NULL
GO
