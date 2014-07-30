SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsEditingTasksData]
AS
SELECT     dbo.Jobs.JobNumber, dbo.vwJobEditingTasks.EditionStage, dbo.Jobs.ReceivedOn, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, 
                      dbo.vwJobEditingTasks.AssignedToID, dbo.JobEditingTasksData.JobEditingTaskId, dbo.JobEditingTasksData.NumPages, dbo.JobEditingTasksData.NumLines, 
                      dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, dbo.JobEditingTasksData.BodyWSpaces, 
                      dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, dbo.JobEditingTasksData.HeaderEvenWSpaces, 
                      dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, dbo.JobEditingTasksData.FooterEvenWSpaces, 
                      dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, 
                      dbo.JobEditingTasksData.DocumentWSpaces
FROM         dbo.Jobs INNER JOIN
                      dbo.vwJobEditingTasks ON dbo.Jobs.JobId = dbo.vwJobEditingTasks.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.vwJobEditingTasks.JobEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId
WHERE     (dbo.vwJobEditingTasks.TaskStatus IN ('C', 'F'))
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[23] 2[20] 3) )"
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
               Top = 34
               Left = 66
               Bottom = 304
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 69
               Left = 761
               Bottom = 293
               Right = 976
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwJobEditingTasks"
            Begin Extent = 
               Top = 38
               Left = 403
               Bottom = 361
               Right = 670
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 24
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
         Column = 5910
         Alias = 5610
         Table = 3180
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy ', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsEditingTasksData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'= 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsEditingTasksData', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwJobsEditingTasksData', NULL, NULL
GO
