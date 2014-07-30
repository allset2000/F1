
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwRptActiveQAJobs]
AS
SELECT     dbo.JobEditingTasks.JobId, dbo.Jobs.JobNumber, dbo.JobEditingTasksData.JobEditingTaskId, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, 
                      dbo.JobEditingTasks.AssignedToID AS EditedByID, vwWorkflowStates_1.StateCode AS PriorEditionMode, dbo.vwWorkflowStates.StateCode AS EditionMode, 
                      dbo.JobEditingTasks.ReceivedOn, dbo.JobEditingTasks.ReturnedOn, dbo.Jobs.CompletedOn, dbo.JobEditingTasksData.NumPages, 
                      dbo.JobEditingTasksData.NumLines, dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, 
                      dbo.JobEditingTasksData.BodyWSpaces, dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, 
                      dbo.JobEditingTasksData.HeaderEvenWSpaces, dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, 
                      dbo.JobEditingTasksData.FooterEvenWSpaces, dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, 
                      dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, dbo.JobEditingTasksData.DocumentWSpaces, dbo.JobEditingTasks.TaskStatus
FROM         dbo.JobEditingTasks INNER JOIN
                      dbo.Jobs ON dbo.JobEditingTasks.JobId = dbo.Jobs.JobId INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingTasks.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId INNER JOIN
                      dbo.JobEditingTasks AS JobEditingTasks_1 ON dbo.JobEditingTasks.PreviousTaskId = JobEditingTasks_1.JobEditingTaskId INNER JOIN
                      dbo.vwWorkflowStates AS vwWorkflowStates_1 ON JobEditingTasks_1.CurrentStateId = vwWorkflowStates_1.WorkflowStateId INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingSummary.EditorEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId
WHERE     (dbo.JobEditingTasks.NextTaskId = - 1) AND (dbo.vwWorkflowStates.QAStage <> '') AND (dbo.JobEditingTasks.TaskStatus <> 'F')
GO

EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[53] 4[15] 2[11] 3) )"
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
         Begin Table = "JobEditingTasks"
            Begin Extent = 
               Top = 1
               Left = 534
               Bottom = 322
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 46
               Left = 1364
               Bottom = 275
               Right = 1543
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 16
               Left = 798
               Bottom = 304
               Right = 1034
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates"
            Begin Extent = 
               Top = 45
               Left = 47
               Bottom = 240
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasks_1"
            Begin Extent = 
               Top = 281
               Left = 175
               Bottom = 436
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates_1"
            Begin Extent = 
               Top = 351
               Left = 604
               Bottom = 555
               Right = 786
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 153
               Left = 1119
               Bottom = 407
              ', 'SCHEMA', N'dbo', 'VIEW', N'vwRptActiveQAJobs', NULL, NULL
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N' Right = 1301
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 29
         Width = 284
         Width = 1830
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2820
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5865
         Alias = 3030
         Table = 1755
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwRptActiveQAJobs', NULL, NULL
GO

DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwRptActiveQAJobs', NULL, NULL
GO
