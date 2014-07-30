SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwDocuments]
AS
SELECT     dbo.vwAllMedicalJobs.JobId, dbo.vwAllMedicalJobs.JobNumber, dbo.vwAllMedicalJobs.JobType, dbo.vwAllMedicalJobs.Stat, 
                      dbo.vwAllMedicalJobs.ClinicID, dbo.vwAllMedicalJobs.ClinicName, dbo.vwAllMedicalJobs.DictatorID, dbo.vwAllMedicalJobs.DictationDate, 
                      dbo.vwAllMedicalJobs.DictationTime, dbo.vwAllMedicalJobs.AppointmentDate, dbo.vwAllMedicalJobs.AppointmentTime, dbo.vwAllMedicalJobs.Duration, 
                      dbo.vwAllMedicalJobs.ReceivedOn, dbo.vwAllMedicalJobs.CompletedOn, dbo.vwAllMedicalJobs.Location, dbo.vwAllMedicalJobs.EditorID, 
                      dbo.vwAllMedicalJobs.EditorFullName, dbo.vwAllMedicalJobs.CC, dbo.Jobs_Documents.Doc, dbo.vwAllMedicalJobs.DocumentStatus, 
                      dbo.vwAllMedicalJobs.PatientAlternateID, dbo.vwAllMedicalJobs.MRN, dbo.vwAllMedicalJobs.PatientName, dbo.vwAllMedicalJobs.PatientFirstName, 
                      dbo.vwAllMedicalJobs.PatientMI, dbo.vwAllMedicalJobs.PatientLastName, dbo.vwAllMedicalJobs.PatientSuffix, dbo.vwAllMedicalJobs.PatientDOB, 
                      dbo.vwAllMedicalJobs.PatientSSN, dbo.vwAllMedicalJobs.PatientAddress1, dbo.vwAllMedicalJobs.PatientAddress2, dbo.vwAllMedicalJobs.PatientCity, 
                      dbo.vwAllMedicalJobs.PatientState, dbo.vwAllMedicalJobs.PatientZip, dbo.vwAllMedicalJobs.PatientPhone, dbo.vwAllMedicalJobs.PatientSex
FROM         dbo.Jobs_Documents INNER JOIN
                      dbo.vwAllMedicalJobs ON dbo.Jobs_Documents.JobNumber = dbo.vwAllMedicalJobs.JobNumber

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[32] 2[17] 3) )"
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
         Begin Table = "Jobs_Documents"
            Begin Extent = 
               Top = 129
               Left = 377
               Bottom = 294
               Right = 641
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "vwJobsForJobSearch"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 218
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
      Begin ColumnWidths = 38
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
         Column = 7380
         Alias = 4050
         Table = 2565
         Output = 720
         Append = 1400
         NewValue = 1170
         So', 'SCHEMA', N'dbo', 'VIEW', N'vwDocuments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'rtType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vwDocuments', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwDocuments', NULL, NULL
GO
