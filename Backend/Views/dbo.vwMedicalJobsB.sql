SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwMedicalJobsB]
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
                      dbo.vwPatients.PatientAlternateID, dbo.vwJobsStatusB.SpeechFolderTag, dbo.vwJobsStatusB.Path AS SpeechDataFolder, dbo.vwJobsStatusB.Status AS JobStatus, 
                      dbo.vwJobsStatusB.StatusClass, 
                      CASE WHEN CurrentQAStage = 'QA4' THEN 'QA2' WHEN CurrentQAStage = 'QA3' THEN 'INVALID_STATE' WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE vwJobsStatusB.StatusStage
                       END AS OldStatusStage, dbo.vwJobsStatusB.StatusDate AS JobStatusDate, dbo.vwJobsStatusB.StatusName AS JobStatusName, 
                       dbo.vwJobsStatusB.FriendlyStatusName AS JobFriendlyStatusName, dbo.vwJobsStatusB.EditionStage, 
                      dbo.Jobs.EditorID, ISNULL(dbo.vwEditors.EditorCompanyId, - 1) AS EditorCompanyId, ISNULL(dbo.vwEditors.EditorCompanyCode, '') AS EditorCompanyCode, 
                      ISNULL(dbo.vwEditors.EditingWorkflowModelId, - 1) AS EditingWorkflowModelId, dbo.JobEditingSummary.LastEditedByID, 
                      dbo.JobEditingSummary.CurrentlyEditedByID, dbo.JobEditingSummary.LastQAEditorID, dbo.JobEditingSummary.CurrentStateId, 
                      CASE WHEN CurrentQAStage <> '' THEN CurrentQAStage ELSE EditionStage END AS CurrentEditingStage, dbo.JobEditingSummary.CurrentQAStage, 
                      dbo.JobEditingSummary.LastQAStage, dbo.JobEditingSummary.AssignedToID, dbo.JobEditingSummary.QACategoryId, dbo.JobEditingSummary.LastQANote, 
                      dbo.JobEditingSummary.QAEditorsList, dbo.JobEditingSummary.FinishedOn, dbo.JobEditingSummary.LastEditingTaskId, 
                      dbo.JobEditingSummary.LastQAEditingTaskId, dbo.Jobs.TemplateName
FROM         dbo.Dictators INNER JOIN
                      dbo.Jobs ON dbo.Dictators.DictatorID = dbo.Jobs.DictatorID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.vwJobsStatusB ON dbo.Jobs.JobNumber = dbo.vwJobsStatusB.JobNumber INNER JOIN
                      dbo.Jobs_Referring ON dbo.Jobs.JobNumber = dbo.Jobs_Referring.JobNumber INNER JOIN
                      dbo.vwPatients ON dbo.Jobs.JobNumber = dbo.vwPatients.JobNumber INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobEditingSummaryId = dbo.JobEditingSummary.JobId LEFT OUTER JOIN
                      dbo.vwEditors ON dbo.Jobs.EditorID = dbo.vwEditors.EditorID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber

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
      ActivePaneConfig = 10
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Dictators"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 114
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 31
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwJobsStatusB"
            Begin Extent = 
               Top = 114
               Left = 253
               Bottom = 222
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Referring"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwPatients"
            Begin Extent = 
               Top = 222
               Left = 227
               Bottom = 330
               Right = 397
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobEditingSummary"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 217
            End
     ', 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobsB', NULL, NULL
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N'       DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwEditors"
            Begin Extent = 
               Top = 330
               Left = 255
               Bottom = 438
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Client"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 3555
         Alias = 1890
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobsB', NULL, NULL
GO


DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwMedicalJobsB', NULL, NULL
GO
