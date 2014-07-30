SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwAllMedicalJobs]
AS
SELECT     dbo.Jobs.JobId, dbo.Jobs.JobNumber, dbo.Jobs.JobType, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.Location, dbo.Jobs.DictatorID, 
                      dbo.Dictators.DictatorIdOk, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, ISNULL(dbo.Jobs.AppointmentDate, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) 
                      AS AppointmentDate, ISNULL(dbo.Jobs.AppointmentTime, CONVERT(DATETIME, '1900-01-01 00:00:00', 102)) AS AppointmentTime, ISNULL(dbo.Jobs.Duration, 0) 
                      AS Duration, ISNULL(dbo.Jobs.ReceivedOn, CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS ReceivedOn, dbo.Jobs.DueDate, ISNULL(dbo.Jobs.CompletedOn, 
                      CONVERT(DATETIME, '2078-12-31 00:00:00', 102)) AS CompletedOn, ISNULL(dbo.Jobs.CC, 0) AS CC, dbo.Jobs.GenericPatientFlag, dbo.Jobs.Stat, 
                      ISNULL(dbo.Jobs.EditorID, '') AS EditorID, ISNULL(dbo.Editors.FirstName, '') + ' ' + ISNULL(dbo.Editors.LastName, '') AS EditorFullName, 
                      ISNULL(dbo.Jobs.DocumentStatus, 0) AS DocumentStatus, ISNULL(dbo.Jobs_Referring.FirstName, '') AS ReferringFirstName, ISNULL(dbo.Jobs_Referring.MI, '') 
                      AS ReferringMI, ISNULL(dbo.Jobs_Referring.LastName, '') AS ReferringLastName, ISNULL(dbo.Jobs_Referring.Address1, '') AS ReferringAddress1, 
                      ISNULL(dbo.Jobs_Referring.Address2, '') AS ReferringAddress2, ISNULL(dbo.Jobs_Referring.City, '') AS ReferringCity, ISNULL(dbo.Jobs_Referring.State, '') 
                      AS ReferringState, ISNULL(dbo.Jobs_Referring.Zip, '') AS ReferringZip, dbo.vwPatients.PatientAlternateID, dbo.vwPatients.MRN, dbo.vwPatients.PatientName, 
                      dbo.vwPatients.PatientFirstName, dbo.vwPatients.PatientMI, dbo.vwPatients.PatientLastName, dbo.vwPatients.PatientSuffix, dbo.vwPatients.PatientDOB, 
                      dbo.vwPatients.PatientSSN, dbo.vwPatients.PatientAddress1, dbo.vwPatients.PatientAddress2, dbo.vwPatients.PatientCity, dbo.vwPatients.PatientState, 
                      dbo.vwPatients.PatientZip, dbo.vwPatients.PatientPhone, dbo.vwPatients.PatientSex, ISNULL(dbo.Jobs_Client.FileName, '') AS CustomerJobNumber, 
                      dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, 
                      dbo.JobEditingSummary.LastQAEditorID, dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.FinishedOn, 
                      dbo.JobEditingSummary.LastQANote, dbo.JobEditingSummary.QAEditorsList
FROM         dbo.Jobs_Referring INNER JOIN
                      dbo.Jobs INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID ON dbo.Jobs_Referring.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber LEFT OUTER JOIN
                      dbo.Editors ON dbo.Jobs.EditorID = dbo.Editors.EditorID
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[24] 2[10] 3) )"
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
         Begin Table = "Jobs_Referring"
            Begin Extent = 
               Top = 128
               Left = 20
               Bottom = 236
               Right = 171
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 31
               Left = 561
               Bottom = 416
               Right = 749
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 222
               Left = 185
               Bottom = 330
               Right = 362
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwPatients"
            Begin Extent = 
               Top = 88
               Left = 835
               Bottom = 196
               Right = 1005
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 213
               Left = 799
               Bottom = 437
               Right = 978
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Dictators"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 314
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "Jobs_Client"
            Begin Extent = 
               Top = 331
               Left = 351
               Bottom = 439
               Right = 502
            End
    ', 'SCHEMA', N'dbo', 'VIEW', N'vwAllMedicalJobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'        DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Editors"
            Begin Extent = 
               Top = 43
               Left = 1224
               Bottom = 151
               Right = 1387
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
      Begin ColumnWidths = 54
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
         Column = 4890
         Alias = 3165
         Table = 3330
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwAllMedicalJobs', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwAllMedicalJobs', NULL, NULL
GO
