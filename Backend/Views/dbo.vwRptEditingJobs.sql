
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwRptEditingJobs]
AS
SELECT     dbo.JobEditingSummary.JobId, dbo.Jobs.JobNumber, dbo.JobEditingTasksData.JobEditingTaskId, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, 
                      dbo.JobEditingTasks.AssignedToID AS EditedByID, CASE WHEN BillingEditingTaskId = JobEditingTasks.JobEditingTaskId THEN 1 ELSE 0 END AS UseForBilling, 
                      dbo.JobEditingTasks.ReceivedOn, dbo.JobEditingTasks.ReturnedOn, dbo.Jobs.CompletedOn, 
                      CASE WHEN vwWorkflowStates.StateCode = 'END_STATE' THEN 1 ELSE 0 END AS IsFinished, dbo.JobEditingTasksData.NumPages, 
                      dbo.JobEditingTasksData.NumLines, dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, 
                      dbo.JobEditingTasksData.BodyWSpaces, dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, 
                      dbo.JobEditingTasksData.HeaderEvenWSpaces, dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, 
                      dbo.JobEditingTasksData.FooterEvenWSpaces, dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, 
                      dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, dbo.JobEditingTasksData.DocumentWSpaces
FROM         dbo.JobEditingTasks INNER JOIN
                      dbo.JobEditingSummary ON dbo.JobEditingTasks.JobId = dbo.JobEditingSummary.JobId AND 
                      dbo.JobEditingTasks.JobEditingTaskId = dbo.JobEditingSummary.EditorEditingTaskId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingTasks.JobEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId INNER JOIN
                      dbo.Jobs ON dbo.JobEditingSummary.JobId = dbo.Jobs.JobId INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingSummary.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId
WHERE     (dbo.JobEditingSummary.JobId <> - 1)
GO

EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[67] 4) )"
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
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JobEditingTasks"
            Begin Extent = 
               Top = 61
               Left = 707
               Bottom = 377
               Right = 912
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 19
               Left = 259
               Bottom = 321
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 2
               Left = 1215
               Bottom = 320
               Right = 1439
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 12
               Left = 37
               Bottom = 572
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates"
            Begin Extent = 
               Top = 301
               Left = 498
               Bottom = 528
               Right = 680
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
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
      End
   End
   Beg', 'SCHEMA', N'dbo', 'VIEW', N'vwRptEditingJobs', NULL, NULL
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N'in CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6570
         Alias = 1125
         Table = 1710
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwRptEditingJobs', NULL, NULL
GO

DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwRptEditingJobs', NULL, NULL
GO
