SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobEditingTasks]
AS
SELECT     dbo.JobEditingTasks.JobEditingTaskId, dbo.JobEditingTasks.JobId, dbo.JobEditingTasks.AssignedToID, dbo.JobEditingTasks.EditionNote, 
                      dbo.JobEditingTasks.QACategoryId, dbo.vwQACategories.QACategory, dbo.JobEditingTasks.CurrentStateId, dbo.JobEditingTasks.NextStateId, 
                      dbo.JobEditingTasks.WorkflowRuleId, dbo.JobEditingTasks.AssignmentMode, dbo.JobEditingTasks.AssignedById, dbo.JobEditingTasks.ReleasedById, 
                      dbo.JobEditingTasks.AssignedOn, dbo.JobEditingTasks.ReceivedOn, dbo.JobEditingTasks.ReturnedOn, dbo.JobEditingTasks.PreviousTaskId, 
                      dbo.JobEditingTasks.NextTaskId, dbo.JobEditingTasks.TaskStatus, dbo.vwWorkflowStates.EditionStage, dbo.vwWorkflowStates.StateCode AS EditionStageStep, 
                      vwWorkflowStates_1.StateCode AS NextState, 
                      CASE dbo.JobEditingTasks.AssignedToID WHEN '' THEN JobEditingTasks_1.AssignedToID ELSE dbo.JobEditingTasks.AssignedToID END AS LastAssignedToID, 
                      CASE dbo.JobEditingTasks.EditionNote WHEN '' THEN JobEditingTasks_1.EditionNote ELSE dbo.JobEditingTasks.EditionNote END AS LastNote
FROM         dbo.JobEditingTasks INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingTasks.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId INNER JOIN
                      dbo.vwWorkflowStates AS vwWorkflowStates_1 ON dbo.JobEditingTasks.NextStateId = vwWorkflowStates_1.WorkflowStateId INNER JOIN
                      dbo.vwQACategories ON dbo.JobEditingTasks.QACategoryId = dbo.vwQACategories.QACategoryId INNER JOIN
                      dbo.JobEditingTasks AS JobEditingTasks_1 ON dbo.JobEditingTasks.PreviousTaskId = JobEditingTasks_1.JobEditingTaskId
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[23] 2[17] 3) )"
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
         Top = -12
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JobEditingTasks"
            Begin Extent = 
               Top = 18
               Left = 531
               Bottom = 394
               Right = 692
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates"
            Begin Extent = 
               Top = 220
               Left = 74
               Bottom = 426
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates_1"
            Begin Extent = 
               Top = 238
               Left = 774
               Bottom = 346
               Right = 956
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwQACategories"
            Begin Extent = 
               Top = 38
               Left = 195
               Bottom = 213
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasks_1"
            Begin Extent = 
               Top = 40
               Left = 825
               Bottom = 229
               Right = 1084
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 22
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
         W', 'SCHEMA', N'dbo', 'VIEW', N'vwJobEditingTasks', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'idth = 1500
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
         Column = 12495
         Alias = 1665
         Table = 4005
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwJobEditingTasks', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwJobEditingTasks', NULL, NULL
GO
