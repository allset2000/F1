SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsForBillingSummary]
AS
SELECT     ClinicID, DictatorID, COUNT(JobId) AS JobsCount, SUM(CASE WHEN [Stat] = 1 THEN 1 ELSE 0 END) AS StatJobsCount, SUM(CASE WHEN [Stat] = 1 THEN 0 ELSE 1 END)
                       AS NoStatJobsCount, SUM(NumPages) AS NumPages, SUM(NumLines) AS NumLines, SUM(NumChars) AS NumChars, SUM(NumVBC) AS NumVBC, SUM(NumCharsPC)
                       AS NumCharsPC, SUM(BodyWSpaces) AS BodyWSpaces, SUM(HeaderFirstWSpaces) AS HeaderFirstWSpaces, SUM(HeaderPrimaryWSpaces) 
                      AS HeaderPrimaryWSpaces, SUM(HeaderEvenWSpaces) AS HeaderEvenWSpaces, SUM(FooterFirstWSpaces) AS FooterFirstWSpaces, SUM(FooterPrimaryWSpaces) 
                      AS FooterPrimaryWSpaces, SUM(FooterEvenWSpaces) AS FooterEvenWSpaces, SUM(HeaderTotalWSpaces) AS HeaderTotalWSpaces, SUM(FooterTotalWSpaces) 
                      AS FooterTotalWSpaces, SUM(HeaderFooterTotalWSpaces) AS HeaderFooterTotalWSpaces, SUM(DocumentWSpaces) AS DocumentWSpaces, SUM(NumTotalMacros) 
                      AS NumTotalMacros, SUM(NumMacrosUnEdited) AS NumMacrosUnEdited, SUM(NumMacrosEdited) AS NumMacrosEdited, SUM(NumCharsUnEditedMacros) 
                      AS NumCharsUnEditedMacros, SUM(NumCharsEditedMacros) AS NumCharsEditedMacros, SUM(NumCharsChangedMacros) AS NumCharsChangedMacros
FROM         dbo.vwJobsForBilling
GROUP BY ClinicID, DictatorID
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[19] 2[7] 3) )"
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
         Begin Table = "vwJobsForBilling"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 507
               Right = 266
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
      Begin ColumnWidths = 28
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 4185
         Alias = 2940
         Table = 3675
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwJobsForBillingSummary', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwJobsForBillingSummary', NULL, NULL
GO
