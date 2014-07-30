SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwQueuesPermissions]
AS
SELECT     dbo.Queue_Dictators.Queue_ID AS QueueID, dbo.Queue_Names.QueueName, dbo.Queue_Names.Type AS QueueType, dbo.Queue_Editors.EditorID, 
                      dbo.Editors.Type AS EditorType, dbo.Queue_Editors.Priority, ISNULL(dbo.Queue_Dictators.ClinicID, 0) AS ClinicID, ISNULL(dbo.Queue_Dictators.Location, 0) 
                      AS Location, ISNULL(dbo.Queue_Dictators.DictatorID, '') AS DictatorID, ISNULL(dbo.Queue_Dictators.Filter, '') AS QueueFilter
FROM         dbo.Queue_Dictators INNER JOIN
                      dbo.Queue_Editors ON dbo.Queue_Dictators.Queue_ID = dbo.Queue_Editors.QueueID INNER JOIN
                      dbo.Queue_Names ON dbo.Queue_Editors.QueueID = dbo.Queue_Names.QueueID INNER JOIN
                      dbo.Editors ON dbo.Queue_Editors.EditorID = dbo.Editors.EditorID


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
         Begin Table = "Queue_Dictators"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 173
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Queue_Editors"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 110
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Queue_Names"
            Begin Extent = 
               Top = 40
               Left = 513
               Bottom = 144
               Right = 673
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1800
         Table = 2025
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwQueuesPermissions', NULL, NULL
GO

DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwQueuesPermissions', NULL, NULL
GO
