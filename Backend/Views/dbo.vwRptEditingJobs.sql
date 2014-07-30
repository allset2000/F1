SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwRptEditingJobs]
AS
SELECT     dbo.JobEditingSummary.JobId, dbo.Jobs.JobNumber, dbo.JobEditingTasksData.JobEditingTaskId, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, 
                      dbo.JobEditingTasks.AssignedToID AS EditedByID, dbo.vwWorkflowStates.StateCode AS EditionMode, 
                      CASE WHEN BillingEditingTaskId = JobEditingTasks.JobEditingTaskId THEN 1 ELSE 0 END AS UseForBilling, dbo.JobEditingTasks.ReceivedOn, 
                      dbo.JobEditingTasks.ReturnedOn, dbo.Jobs.CompletedOn, dbo.JobEditingTasksData.NumPages, dbo.JobEditingTasksData.NumLines, 
                      dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, dbo.JobEditingTasksData.BodyWSpaces, 
                      dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, dbo.JobEditingTasksData.HeaderEvenWSpaces, 
                      dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, dbo.JobEditingTasksData.FooterEvenWSpaces, 
                      dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, 
                      dbo.JobEditingTasksData.DocumentWSpaces
FROM         dbo.JobEditingTasks INNER JOIN
                      dbo.JobEditingSummary ON dbo.JobEditingTasks.JobId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingTasks.JobEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId INNER JOIN
                      dbo.Jobs ON dbo.JobEditingTasks.JobId = dbo.Jobs.JobId INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingTasks.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId
WHERE     (NOT (dbo.Jobs.CompletedOn IS NULL)) AND (dbo.JobEditingSummary.JobId <> - 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[33] 2[15] 3) )"
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
               Top = 29
               Left = 645
               Bottom = 350
               Right = 806
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 99
               Left = 303
               Bottom = 379
               Right = 482
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 42
               Left = 25
               Bottom = 320
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 60
               Left = 1102
               Bottom = 168
               Right = 1290
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates"
            Begin Extent = 
               Top = 228
               Left = 1014
               Bottom = 336
               Right = 1196
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
      Begin ColumnWidths = 28
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
         Width = 15', 'SCHEMA', N'dbo', 'VIEW', N'vwRptEditingJobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'00
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
         Column = 7335
         Alias = 1620
         Table = 2775
         Output = 1575
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
