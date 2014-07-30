SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsForBilling]
AS
SELECT     dbo.JobEditingSummary.JobId, dbo.Jobs.JobNumber, dbo.Jobs.ClinicID, dbo.Jobs.ReceivedOn, dbo.Jobs.CompletedOn, dbo.Dictators.DictatorIdOk, 
                      dbo.Jobs.DictatorID, dbo.Jobs.Stat, dbo.Jobs.JobType, dbo.JobEditingTasksData.JobEditingTaskId, dbo.JobEditingTasksData.NumPages, 
                      dbo.JobEditingTasksData.NumLines, dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, 
                      dbo.JobEditingTasksData.BodyWSpaces, dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, 
                      dbo.JobEditingTasksData.HeaderEvenWSpaces, dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, 
                      dbo.JobEditingTasksData.FooterEvenWSpaces, dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, 
                      dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, dbo.JobEditingTasksData.DocumentWSpaces, dbo.JobEditingTasksData.NumTotalMacros, 
                      dbo.JobEditingTasksData.NumMacrosUnEdited, dbo.JobEditingTasksData.NumMacrosEdited, dbo.JobEditingTasksData.NumCharsUnEditedMacros, 
                      dbo.JobEditingTasksData.NumCharsEditedMacros, dbo.JobEditingTasksData.NumCharsChangedMacros
FROM         dbo.Jobs INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingSummary.BillingEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID
WHERE     (dbo.Jobs.CompletedOn IS NOT NULL)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[59] 4[15] 2[8] 3) )"
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
               Bottom = 444
               Right = 283
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 7
               Left = 311
               Bottom = 350
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingTasksData"
            Begin Extent = 
               Top = 14
               Left = 538
               Bottom = 457
               Right = 900
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Dictators"
            Begin Extent = 
               Top = 6
               Left = 938
               Bottom = 328
               Right = 1115
            End
            DisplayFlags = 280
            TopColumn = 20
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 33
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
         Width = 1500
    ', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsForBilling', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'     Width = 1500
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
         Column = 3195
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsForBilling', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwJobsForBilling', NULL, NULL
GO
