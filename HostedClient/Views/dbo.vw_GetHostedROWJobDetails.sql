SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_GetHostedROWJobDetails]
AS
SELECT        cJ.JobNumber AS 'ClientJobNumber', cS.EHREncounterID, cJ.JobNumber, cJ.ClinicID, JP.AlternateID, JP.MRN, JP.FirstName, JP.MI, JP.LastName, JP.Suffix, JP.DOB, 
                         CONVERT(varchar(8), CAST(JP.DOB AS DATETIME), 112) AS HL7DOB, JP.Address1, JP.Address2, JP.City, JP.State, JP.Zip, JP.Gender, JP.PatientID, cS.AppointmentID,
                          C.EHRClinicID, C.ClinicCode, cP.Signature, cP.LastName AS ProviderLastName, cP.FirstName AS ProviderFirstName, cP.MI AS ProviderMI, cP.EHRProviderID, 
                         cP.EHRProviderAlias
FROM            dbo.Jobs AS cJ INNER JOIN
                         dbo.Clinics AS C ON C.ClinicID = cJ.ClinicID INNER JOIN
                         dbo.Encounters AS cE ON cE.EncounterID = cJ.EncounterID INNER JOIN
                         dbo.Schedules AS cS ON cS.ScheduleID = cE.ScheduleID INNER JOIN
                         dbo.Patients AS JP ON JP.PatientID = cS.PatientID INNER JOIN
                         dbo.Dictations AS cD ON cD.JobID = cJ.JobID INNER JOIN
                         dbo.Dictators AS cP ON cP.DictatorID = cD.DictatorID
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
         Begin Table = "cJ"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 273
               Bottom = 135
               Right = 519
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cE"
            Begin Extent = 
               Top = 6
               Left = 557
               Bottom = 135
               Right = 741
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cS"
            Begin Extent = 
               Top = 6
               Left = 779
               Bottom = 135
               Right = 963
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JP"
            Begin Extent = 
               Top = 6
               Left = 1001
               Bottom = 135
               Right = 1210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cD"
            Begin Extent = 
               Top = 6
               Left = 1248
               Bottom = 135
               Right = 1422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cP"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         En', 'SCHEMA', N'dbo', 'VIEW', N'vw_GetHostedROWJobDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'd
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_GetHostedROWJobDetails', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_GetHostedROWJobDetails', NULL, NULL
GO
