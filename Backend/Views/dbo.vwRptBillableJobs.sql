
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwRptBillableJobs]
AS
SELECT     dbo.JobEditingSummary.JobId, dbo.Jobs.JobNumber, dbo.JobEditingTasks.JobEditingTaskId, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, dbo.Jobs.EditorID, 
                      dbo.Jobs.ReceivedOn, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, CASE WHEN vwWorkflowStates.StateCode = 'END_STATE' THEN 1 ELSE 0 END AS IsFinished, 
                      dbo.JobEditingTasksData.NumPages, dbo.JobEditingTasksData.NumLines, dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, 
                      dbo.JobEditingTasksData.NumCharsPC, dbo.JobEditingTasksData.BodyWSpaces, dbo.JobEditingTasksData.HeaderFirstWSpaces, 
                      dbo.JobEditingTasksData.HeaderPrimaryWSpaces, dbo.JobEditingTasksData.HeaderEvenWSpaces, dbo.JobEditingTasksData.FooterFirstWSpaces, 
                      dbo.JobEditingTasksData.FooterPrimaryWSpaces, dbo.JobEditingTasksData.FooterEvenWSpaces, dbo.JobEditingTasksData.HeaderTotalWSpaces, 
                      dbo.JobEditingTasksData.FooterTotalWSpaces, dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, dbo.JobEditingTasksData.DocumentWSpaces
FROM         dbo.Jobs INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.JobEditingTasks ON dbo.JobEditingSummary.JobId = dbo.JobEditingTasks.JobId AND 
                      dbo.JobEditingSummary.BillingEditingTaskId = dbo.JobEditingTasks.JobEditingTaskId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingTasks.JobEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingSummary.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
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
         Column = 3060
         Alias = 1125
         Table = 2145
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwRptBillableJobs', NULL, NULL
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 69
               Left = 340
               Bottom = 234
               Right = 519
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasks"
            Begin Extent = 
               Top = 60
               Left = 704
               Bottom = 168
               Right = 865
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 116
               Left = 1011
               Bottom = 224
               Right = 1226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwWorkflowStates"
            Begin Extent = 
               Top = 199
               Left = 590
               Bottom = 369
               Right = 798
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
      Begin ColumnWidths = 27
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
         Width = 1500', 'SCHEMA', N'dbo', 'VIEW', N'vwRptBillableJobs', NULL, NULL
GO

DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwRptBillableJobs', NULL, NULL
GO
