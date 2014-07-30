SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwMedicalJobs]
AS
SELECT     dbo.Jobs.JobNumber, dbo.Jobs.JobId, dbo.Jobs.DictatorID, dbo.Dictators.DictatorIdOk, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Jobs.Location, 
                      dbo.Dictators.TemplatesFolder, dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs.Vocabulary, 
                      dbo.Jobs.Stat, dbo.Jobs.CC, dbo.Jobs.GenericPatientFlag, dbo.Jobs.Duration, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, dbo.Jobs.ReceivedOn, 
                      dbo.Jobs.DueDate, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, dbo.Jobs.RecServer, dbo.Jobs.BilledOn, dbo.Jobs.Amount, dbo.Jobs.ParentJobNumber, 
                      ISNULL(dbo.Jobs_Client.FileName, '') AS CustomerJobNumber, dbo.Jobs.DocumentStatus, ISNULL(dbo.Dictators.VREnabled, 0) AS VREnabled, 
                      ISNULL(dbo.Dictators.FirstName, '') AS FirstName, ISNULL(dbo.Dictators.MI, '') AS MI, ISNULL(dbo.Dictators.LastName, '') AS LastName, ISNULL(dbo.Dictators.Suffix, 
                      '') AS Suffix, ISNULL(dbo.Dictators.Initials, '') AS Initials, ISNULL(dbo.Dictators.Signature, '') AS Signature, ISNULL(dbo.Dictators.User_Code, '') AS User_Code, 
                      dbo.Dictators.FirstName AS DictatorFirstName, ISNULL(dbo.Dictators.MI, '') AS DictatorMI, dbo.Dictators.LastName AS DictatorLastName, 
                      ISNULL(dbo.Jobs_Referring.FirstName, '') AS ReferringFirstName, ISNULL(dbo.Jobs_Referring.MI, '') AS ReferringMI, ISNULL(dbo.Jobs_Referring.LastName, '') 
                      AS ReferringLastName, ISNULL(dbo.Jobs_Referring.Address1, '') AS ReferringAddress1, ISNULL(dbo.Jobs_Referring.Address2, '') AS ReferringAddress2, 
                      ISNULL(dbo.Jobs_Referring.City, '') AS ReferringCity, ISNULL(dbo.Jobs_Referring.State, '') AS ReferringState, ISNULL(dbo.Jobs_Referring.Zip, '') AS ReferringZip, 
                      dbo.vwPatients.MRN, dbo.vwPatients.PatientName, dbo.vwPatients.PatientFirstName, dbo.vwPatients.PatientMI, dbo.vwPatients.PatientLastName, 
                      dbo.vwPatients.PatientSuffix, dbo.vwPatients.PatientDOB, dbo.vwPatients.PatientSSN, dbo.vwPatients.PatientAddress1, dbo.vwPatients.PatientAddress2, 
                      dbo.vwPatients.PatientCity, dbo.vwPatients.PatientState, dbo.vwPatients.PatientZip, dbo.vwPatients.PatientPhone, dbo.vwPatients.PatientSex, 
                      dbo.vwPatients.PatientAlternateID, dbo.vwJobsStatusA.SpeechFolderTag, dbo.vwJobsStatusA.Path AS SpeechDataFolder, dbo.vwJobsStatusA.Status AS JobStatus, 
                      dbo.vwJobsStatusA.StatusClass, 
                      CASE WHEN CurrentQAStage = 'QA4' THEN 'QA2' WHEN CurrentQAStage = 'QA3' THEN 'INVALID_STATE' WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE vwJobsStatusA.StatusStage
                       END AS OldStatusStage, dbo.vwJobsStatusA.StatusDate AS JobStatusDate, dbo.vwJobsStatusA.StatusName AS JobStatusName, 
                      dbo.vwJobsStatusA.FriendlyStatusName AS JobFriendlyStatusName, dbo.vwJobsStatusA.EditionStage, dbo.Jobs.EditorID, ISNULL(dbo.vwEditors.EditorCompanyId, - 1)
                       AS EditorCompanyId, ISNULL(dbo.vwEditors.EditorCompanyCode, '') AS EditorCompanyCode, ISNULL(dbo.vwEditors.EditingWorkflowModelId, - 1) 
                      AS EditingWorkflowModelId, dbo.JobEditingSummary.LastEditedByID, dbo.JobEditingSummary.CurrentlyEditedByID, dbo.JobEditingSummary.LastQAEditorID, 
                      dbo.JobEditingSummary.CurrentStateId, CASE WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE EditionStage END AS CurrentEditingStage, 
                      dbo.JobEditingSummary.CurrentQAStage, dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.QACategoryId, 
                      dbo.JobEditingSummary.LastQANote, dbo.JobEditingSummary.QAEditorsList, dbo.JobEditingSummary.FinishedOn, dbo.JobEditingSummary.LastEditingTaskId, 
                      dbo.JobEditingSummary.LastQAEditingTaskId, dbo.vwQACategories.QACategory, vwQACategories_1.QACategory AS QAParentCategory
FROM         dbo.Dictators INNER JOIN
                      dbo.Jobs ON dbo.Dictators.DictatorID = dbo.Jobs.DictatorID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.vwJobsStatusA ON dbo.Jobs.JobNumber = dbo.vwJobsStatusA.JobNumber INNER JOIN
                      dbo.Jobs_Referring ON dbo.Jobs.JobNumber = dbo.Jobs_Referring.JobNumber INNER JOIN
                      dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.vwQACategories ON dbo.JobEditingSummary.QACategoryId = dbo.vwQACategories.QACategoryId INNER JOIN
                      dbo.vwQACategories AS vwQACategories_1 ON dbo.vwQACategories.ParentId = vwQACategories_1.QACategoryId LEFT OUTER JOIN
                      dbo.vwEditors ON dbo.Jobs.EditorID = dbo.vwEditors.EditorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[22] 2[11] 3) )"
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
         Top = -250
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Dictators"
            Begin Extent = 
               Top = 0
               Left = 0
               Bottom = 228
               Right = 177
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 10
               Left = 371
               Bottom = 639
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 218
               Left = 54
               Bottom = 326
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwJobsStatusA"
            Begin Extent = 
               Top = 4
               Left = 667
               Bottom = 228
               Right = 833
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Referring"
            Begin Extent = 
               Top = 375
               Left = 97
               Bottom = 483
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwPatients"
            Begin Extent = 
               Top = 49
               Left = 992
               Bottom = 157
               Right = 1162
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 431
               Left = 661
               Bottom = 772
               Right = 861
            End
    ', 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'        DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "vwQACategories"
            Begin Extent = 
               Top = 347
               Left = 942
               Bottom = 537
               Right = 1135
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwQACategories_1"
            Begin Extent = 
               Top = 344
               Left = 1164
               Bottom = 612
               Right = 1357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwEditors"
            Begin Extent = 
               Top = 272
               Left = 661
               Bottom = 380
               Right = 856
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Client"
            Begin Extent = 
               Top = 220
               Left = 1090
               Bottom = 328
               Right = 1241
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
      Begin ColumnWidths = 92
         Width = 284
         Width = 2775
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
         Width = 2175
         Width = 1500
         Width = 2430
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2640
         Width = 1500
         Width = 2205
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
         Column = 2955
         Alias = 2925
         Table = 2895
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 135', 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobs', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'0
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobs', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=3
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobs', NULL, NULL
GO
