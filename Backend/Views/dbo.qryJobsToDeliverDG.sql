SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobsToDeliverDG]
AS
SELECT     dbo.JobsToDeliver.JobNumber, dbo.JobsToDeliver.Method, dbo.JobsToDeliver.RuleName, dbo.Clinics.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.DictatorID, 
                      dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, 
                      dbo.Jobs_Patients.LastName, dbo.Jobs_Patients.DOB, dbo.Jobs_Custom.Custom1, dbo.Jobs_Custom.Custom6, dbo.Jobs_Custom.Custom12
FROM         dbo.JobsToDeliver INNER JOIN
                      dbo.Jobs ON dbo.JobsToDeliver.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
                      dbo.Jobs_Custom ON dbo.Jobs.JobNumber = dbo.Jobs_Custom.JobNumber

GO

EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[42] 2[12] 3) )"
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
         Begin Table = "JobsToDeliver"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 411
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 6
               Left = 449
               Bottom = 125
               Right = 635
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Patients"
            Begin Extent = 
               Top = 6
               Left = 673
               Bottom = 125
               Right = 833
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Custom"
            Begin Extent = 
               Top = 6
               Left = 871
               Bottom = 235
               Right = 1031
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
        ', 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverDG', NULL, NULL
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N' Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverDG', NULL, NULL
GO


DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverDG', NULL, NULL
GO
