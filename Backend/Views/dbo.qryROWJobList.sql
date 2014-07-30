SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryROWJobList]
AS
SELECT     dbo.Jobs.JobNumber, dbo.Jobs.DictatorID, dbo.Jobs.ClinicID, dbo.Jobs.Location, dbo.Jobs.AppointmentDate, dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs.ContextName, 
                      dbo.Jobs.Vocabulary, dbo.Jobs.Stat, dbo.Jobs.CC, dbo.Jobs.Duration, dbo.Jobs.DictationDate, dbo.Jobs.DictationTime, dbo.Jobs.ReceivedOn, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, 
                      dbo.Jobs.RecServer, dbo.Jobs.EditorID, dbo.Jobs.BilledOn, dbo.Jobs.Amount, dbo.Jobs.ParentJobNumber, dbo.Jobs.DocumentStatus, dbo.Jobs.AppointmentId, dbo.Jobs.DocumentId, 
                      dbo.Jobs.JobId, dbo.Jobs.JobStatus, dbo.Jobs.JobStatusDate, dbo.Jobs.JobPath, dbo.Jobs.GenericPatientFlag, dbo.Jobs.PoorAudioFlag, dbo.Jobs.TranscriptionModeFlag, 
                      dbo.Jobs.JobEditingSummaryId, dbo.Jobs_Patients.AlternateID, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, dbo.Jobs_Patients.MI, dbo.Jobs_Patients.LastName, 
                      dbo.Jobs_Patients.Suffix, dbo.Jobs_Patients.DOB, dbo.Jobs_Patients.SSN, dbo.Jobs_Patients.Address1, dbo.Jobs_Patients.Address2, dbo.Jobs_Patients.City, dbo.Jobs_Patients.State, 
                      dbo.Jobs_Patients.Zip, dbo.Jobs_Patients.Phone, dbo.Jobs_Patients.Sex, dbo.Jobs_Patients.PatientId, dbo.Jobs_Patients.AppointmentId AS PatAppointmentId, dbo.Jobs_Custom.Custom1, 
                      dbo.Jobs_Custom.Custom2, dbo.Jobs_Custom.Custom3, dbo.Jobs_Custom.Custom4, dbo.Jobs_Custom.Custom5, dbo.Jobs_Custom.Custom6, dbo.Jobs_Custom.Custom7, 
                      dbo.Jobs_Custom.Custom8, dbo.Jobs_Custom.Custom9, dbo.Jobs_Custom.Custom10, dbo.Jobs_Custom.Custom11, dbo.Jobs_Custom.Custom12, dbo.Jobs_Custom.Custom13, 
                      dbo.Jobs_Custom.Custom14, dbo.Jobs_Custom.Custom15, dbo.Jobs_Custom.Custom16, dbo.Jobs_Custom.Custom17, dbo.Jobs_Custom.Custom18, dbo.Jobs_Custom.Custom19, 
                      dbo.Jobs_Custom.Custom20, dbo.Jobs_Custom.Custom21, dbo.Jobs_Custom.Custom22, dbo.Jobs_Custom.Custom23, dbo.Jobs_Custom.Custom24, dbo.Jobs_Custom.Custom25, 
                      dbo.Jobs_Custom.Custom26, dbo.Jobs_Custom.Custom27, dbo.Jobs_Custom.Custom28, dbo.Jobs_Custom.Custom29, dbo.Jobs_Custom.Custom30, dbo.Jobs_Custom.Custom31, 
                      dbo.Jobs_Custom.Custom32, dbo.Jobs_Custom.Custom33, dbo.Jobs_Custom.Custom34, dbo.Jobs_Custom.Custom35, dbo.Jobs_Custom.Custom36, dbo.Jobs_Custom.Custom37, 
                      dbo.Jobs_Custom.Custom38, dbo.Jobs_Custom.Custom39, dbo.Jobs_Custom.Custom40, dbo.Jobs_Custom.Custom41, dbo.Jobs_Custom.Custom42, dbo.Jobs_Custom.Custom43, 
                      dbo.Jobs_Custom.Custom44, dbo.Jobs_Custom.Custom45, dbo.Jobs_Custom.Custom46, dbo.Jobs_Custom.Custom47, dbo.Jobs_Custom.Custom48, dbo.Jobs_Custom.Custom49, 
                      dbo.Jobs_Custom.Custom50, dbo.JobsToDeliver.RuleName, JR.PhysicianID AS RefPhysicianID, JR.FirstName AS RefFirstName, JR.MI AS RefMI, JR.LastName AS RefLastName, 
                      JR.Suffix AS RefSuffix, JR.DOB AS RefDOB, JR.SSN AS RefSSN, JR.Sex AS RefSex, JR.Address1 AS RefAddress1, JR.Address2 AS RefAddress2, JR.City AS RefCity, JR.State AS RefState, 
                      JR.Zip AS RefZip, JR.Phone AS RefPhone, JR.Fax AS RefFax, JR.ClinicName AS RefClinicName, dbo.Jobs_Client.FileName AS ClientJobNumber, dbo.JobsToDeliver.DeliveryID, 
                      dbo.JobsToDeliver.Method, dbo.JobsToDeliver.LastUpdatedOn, dbo.Dictators.FirstName AS DictatorFirstName, dbo.Dictators.MI AS DictatorMI, dbo.Dictators.LastName AS DictatorLastName, 
                      dbo.Dictators.Suffix AS DictatorSuffix, dbo.Dictators.Initials AS DictatorInitials, dbo.Dictators.Signature AS DictatorSignature, dbo.Dictators.User_Code AS DictatorUserCode, 
                      dbo.Dictators.EHRProviderID, dbo.Dictators.EHRAliasID, dbo.Clinics.EHRClinicID
FROM         dbo.JobsToDeliver INNER JOIN
                      dbo.Jobs ON dbo.JobsToDeliver.JobNumber = dbo.Jobs.JobNumber INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber INNER JOIN
                      dbo.Jobs_Referring AS JR ON dbo.Jobs.JobNumber = JR.JobNumber INNER JOIN
                      dbo.Jobs_Custom ON dbo.Jobs.JobNumber = dbo.Jobs_Custom.JobNumber INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID LEFT OUTER JOIN
                      dbo.Jobs_Client ON dbo.Jobs.JobNumber = dbo.Jobs_Client.JobNumber
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[56] 4[14] 2[13] 3) )"
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
         Configuration = "(H (1[26] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "JobsToDeliver"
            Begin Extent = 
               Top = 59
               Left = 46
               Bottom = 197
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 74
               Left = 282
               Bottom = 327
               Right = 479
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Patients"
            Begin Extent = 
               Top = 229
               Left = 508
               Bottom = 349
               Right = 668
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JR"
            Begin Extent = 
               Top = 201
               Left = 91
               Bottom = 402
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Custom"
            Begin Extent = 
               Top = 75
               Left = 1072
               Bottom = 195
               Right = 1232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Dictators"
            Begin Extent = 
               Top = 141
               Left = 794
               Bottom = 432
               Right = 980
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 415
               Left = 65
               Bottom = 747
               Right = 251
            End
            Displa', 'SCHEMA', N'dbo', 'VIEW', N'qryROWJobList', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'yFlags = 280
            TopColumn = 4
         End
         Begin Table = "Jobs_Client"
            Begin Extent = 
               Top = 0
               Left = 508
               Bottom = 120
               Right = 668
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2010
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
         Column = 1845
         Alias = 1515
         Table = 1230
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
', 'SCHEMA', N'dbo', 'VIEW', N'qryROWJobList', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'qryROWJobList', NULL, NULL
GO
