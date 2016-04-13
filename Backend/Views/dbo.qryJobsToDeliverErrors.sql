SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[qryJobsToDeliverErrors]
AS
SELECT     TOP (100) PERCENT dbo.JobsToDeliver.DeliveryID, dbo.JobsToDeliver.JobNumber, dbo.JobsToDeliver.Method, dbo.JobsDeliveryMethods.Description, 
                      dbo.JobsToDeliver.RuleName, dbo.Jobs.ClinicID, dbo.Clinics.ClinicName, dbo.Clinics.ClinicCode, dbo.Jobs.DictatorID, dbo.Jobs.AppointmentDate, 
                      dbo.Jobs.AppointmentTime, dbo.Jobs.JobType, dbo.Jobs_Patients.MRN, dbo.Jobs_Patients.FirstName, dbo.Jobs_Patients.LastName, 
                      dbo.qryJobsToDeliverErrors_10.ConfigurationName, dbo.qryJobsToDeliverErrors_10.ErrorId, dbo.qryJobsToDeliverErrors_10.ErrorDate, 
                      dbo.qryJobsToDeliverErrors_10.Message, dbo.qryJobsToDeliverErrors_10.ErrorMessage, dbo.qryJobsToDeliverErrors_10.ExceptionMessage, 
                      dbo.qryJobsToDeliverErrors_10.StackTrace
FROM         dbo.Jobs INNER JOIN
                      dbo.JobsToDeliver ON dbo.Jobs.JobNumber = dbo.JobsToDeliver.JobNumber INNER JOIN
                      dbo.qryJobsToDeliverErrors_10 ON dbo.JobsToDeliver.DeliveryID = dbo.qryJobsToDeliverErrors_10.DeliveryId INNER JOIN
                      dbo.JobsDeliveryMethods ON dbo.JobsToDeliver.Method = dbo.JobsDeliveryMethods.JobDeliveryID INNER JOIN
                      dbo.Clinics ON dbo.Jobs.ClinicID = dbo.Clinics.ClinicID INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber
ORDER BY dbo.JobsToDeliver.DeliveryID, dbo.qryJobsToDeliverErrors_10.ErrorDate


GO

EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[20] 4[38] 2[26] 3) )"
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
         Begin Table = "Jobs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "JobsToDeliver"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 114
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "qryJobsToDeliverErrors_10"
            Begin Extent = 
               Top = 6
               Left = 457
               Bottom = 114
               Right = 629
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "JobsDeliveryMethods"
            Begin Extent = 
               Top = 114
               Left = 248
               Bottom = 192
               Right = 399
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 192
               Left = 248
               Bottom = 300
               Right = 425
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Jobs_Patients"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
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
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Widt', 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverErrors', NULL, NULL
GO

EXEC sp_addextendedproperty N'MS_DiagramPane2', N'h = 1500
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
         Column = 2205
         Alias = 900
         Table = 2175
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
', 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverErrors', NULL, NULL
GO


DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'qryJobsToDeliverErrors', NULL, NULL
GO
