
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =============================================
 Author: Mikayil Bayramov
 Create date: 12/10/2014
 Description: View called from sp_GetEncountersToSync to pull encounters to sync
 =============================================*/
CREATE VIEW [dbo].[vw_GetEncountersToSync]
AS
SELECT        e.EncounterID, e.AppointmentDate, e.PatientID, e.ScheduleID, d.DictatorID AS Dictations_DictatorID, qu.DictatorID AS Queue_Users_DictatorID, j.JobID
FROM            dbo.Dictations AS d INNER JOIN
                         dbo.Jobs AS j ON d.JobID = j.JobID INNER JOIN
                         dbo.Encounters AS e ON j.EncounterID = e.EncounterID INNER JOIN
                         dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID INNER JOIN
                         dbo.Queues AS q ON q.QueueID = qu.QueueID
WHERE        (d.Status IN (200, 100)) AND (q.Deleted = 0)
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
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "j"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 135
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qu"
            Begin Extent = 
               Top = 138
               Left = 260
               Bottom = 233
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 234
               Left = 260
               Bottom = 363
               Right = 434
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_GetEncountersToSync', NULL, NULL
GO

DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_GetEncountersToSync', NULL, NULL
GO
