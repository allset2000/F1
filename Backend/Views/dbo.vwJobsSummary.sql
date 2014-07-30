SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwJobsSummary]
AS
SELECT     JobNumber, DictatorID, ClinicID, ClinicName, Location, TemplatesFolder, AppointmentDate, AppointmentTime, JobType, ContextName, Vocabulary, Stat, CC, Duration, 
                      DictationDate, DictationTime, ReceivedOn, ReturnedOn, CompletedOn, RecServer, EditorID, BilledOn, Amount, ParentJobNumber, DocumentStatus, VREnabled, 
                      JobStatus, StatusClass, OldStatusStage AS StatusStage, JobStatusDate, JobStatusName, SpeechFolderTag, SpeechDataFolder, FirstName, MI, LastName, Suffix, 
                      Initials, Signature, User_Code, DictatorFirstName, DictatorMI, DictatorLastName, ReferringFirstName, ReferringMI, ReferringLastName, ReferringAddress1, 
                      ReferringAddress2, ReferringCity, ReferringState, ReferringZip, MRN, PatientName, PatientFirstName, PatientMI, PatientLastName, PatientSuffix, PatientDOB, 
                      PatientSSN, PatientAddress1, PatientAddress2, PatientCity, PatientState, PatientZip, PatientPhone, PatientSex, PatientAlternateID, CASE WHEN DATEDIFF(minute, 
                      ReceivedOn, GETDATE()) <= 60 AND Stat = 1 THEN 1 ELSE 0 END AS Less_OneHour, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 60 AND 
                      Stat = 1 THEN 1 ELSE 0 END AS Great_OneHour, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 360 AND Stat = 0 THEN 1 ELSE 0 END AS Less_SixHours,
                       CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 720) AND 
                      Stat = 0 THEN 1 ELSE 0 END AS Great_SixHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, ReceivedOn, GETDATE()) 
                      <= 1080) AND Stat = 0 THEN 1 ELSE 0 END AS Great_TwelveHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, 
                      ReceivedOn, GETDATE()) <= 1440) AND Stat = 0 THEN 1 ELSE 0 END AS Great_EighteenHours, CASE WHEN (DATEDIFF(minute, ReceivedOn, GETDATE()) > 1440 AND 
                      DATEDIFF(minute, ReceivedOn, GETDATE()) <= 2880) AND Stat = 0 THEN 1 ELSE 0 END AS Great_TwentyFourHours, CASE WHEN DATEDIFF(minute, ReceivedOn, 
                      GETDATE()) > 2880 AND Stat = 0 THEN 1 ELSE 0 END AS Great_FortyEightHours, CASE WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 60 AND 
                      Stat = 1 THEN 7 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 60 AND Stat = 1 THEN 8 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) <= 360 AND 
                      Stat = 0 THEN 1 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 720 AND 
                      Stat = 0 THEN 2 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 1080 AND 
                      Stat = 0 THEN 3 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 1440 AND 
                      Stat = 0 THEN 4 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 1440 AND DATEDIFF(minute, ReceivedOn, GETDATE()) <= 2880 AND 
                      Stat = 0 THEN 5 WHEN DATEDIFF(minute, ReceivedOn, GETDATE()) > 2880 AND Stat = 0 THEN 6 END AS Dashboard_Id
FROM         dbo.vwMedicalJobs
WHERE     (JobStatus < 240)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[33] 2[21] 3) )"
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
         Begin Table = "vwMedicalJobs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 267
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 35
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 5355
         Alias = 2205
         Table = 2760
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsSummary', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwJobsSummary', NULL, NULL
GO
