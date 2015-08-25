
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_GetROWJobDetails]
AS
SELECT        JCL.FileName AS ClientJobNumber, cS.EHREncounterID, cS.AppointmentID, J.JobNumber, J.DictatorID, J.ClinicID, J.JobType, J.ContextName, J.EditorID, 
                         JP.AlternateID, JP.MRN, JP.FirstName, JP.MI, JP.LastName, JP.Suffix, JP.DOB, CONVERT(varchar(8), CAST(JP.DOB AS DATETIME), 112) AS HL7DOB, JP.SSN, 
                         JP.Address1, JP.Address2, JP.City, JP.State, JP.Zip, JP.Phone, JP.Sex, JP.PatientId, JP.AppointmentId AS Expr1, C.EHRClinicID, C.ClinicCode, C.ClinicName, 
                         cP.Signature, cP.LastName AS ProviderLastName, cP.FirstName AS ProviderFirstName, cP.MI AS ProviderMI, cP.EHRProviderID, cP.EHRProviderAlias, JC.Custom1, 
                         JC.Custom2, JC.Custom3, JC.Custom4, JC.Custom5, JC.Custom6, JC.Custom7, JC.Custom8, JC.Custom9, JC.Custom10, JC.Custom11, JC.Custom12, JC.Custom13, 
                         JC.Custom14, JC.Custom15, JC.Custom16, JC.Custom17, JC.Custom18, JC.Custom19, JC.Custom20, JC.Custom21, JC.Custom22, JC.Custom23, JC.Custom24, 
                         JC.Custom25, JC.Custom26, JC.Custom27, JC.Custom28, JC.Custom29, JC.Custom30, JC.Custom31, JC.Custom32, JC.Custom33, JC.Custom34, JC.Custom35, 
                         JC.Custom36, JC.Custom37, JC.Custom38, JC.Custom39, JC.Custom40, JC.Custom41, JC.Custom42, JC.Custom43, JC.Custom44, JC.Custom45, JC.Custom46, 
                         JC.Custom47, JC.Custom48, JC.Custom49, JC.Custom50
FROM            dbo.EN_Jobs AS J INNER JOIN
                         dbo.EN_Jobs_Patients AS JP ON JP.JobNumber = J.JobNumber INNER JOIN
                         dbo.EN_Jobs_Custom AS JC ON JC.JobNumber = J.JobNumber INNER JOIN
                         dbo.EN_Clinics AS C ON C.ClinicID = J.ClinicID INNER JOIN
                         dbo.EN_Jobs_Client AS JCL ON JCL.JobNumber = J.JobNumber INNER JOIN
                         dbo.Jobs AS cJ ON cJ.JobNumber = JCL.FileName INNER JOIN
                         dbo.Encounters AS cE ON cE.EncounterID = cJ.EncounterID INNER JOIN
                         dbo.Schedules AS cS ON cS.ScheduleID = cE.ScheduleID INNER JOIN
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
         Begin Table = "J"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JP"
            Begin Extent = 
               Top = 6
               Left = 288
               Bottom = 135
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JC"
            Begin Extent = 
               Top = 6
               Left = 496
               Bottom = 135
               Right = 666
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 704
               Bottom = 135
               Right = 902
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JCL"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cJ"
            Begin Extent = 
               Top = 138
               Left = 246
               Bottom = 267
               Right = 443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cE"
            Begin Extent = 
               Top = 138
               Left = 481
               Bottom = 267
               Right = 665
            End
            DisplayFlags = 280
            TopColumn = 0
         En', 'SCHEMA', N'dbo', 'VIEW', N'vw_GetROWJobDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'd
         Begin Table = "cS"
            Begin Extent = 
               Top = 138
               Left = 703
               Bottom = 267
               Right = 887
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cD"
            Begin Extent = 
               Top = 6
               Left = 940
               Bottom = 135
               Right = 1114
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cP"
            Begin Extent = 
               Top = 6
               Left = 1152
               Bottom = 135
               Right = 1334
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_GetROWJobDetails', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_GetROWJobDetails', NULL, NULL
GO
