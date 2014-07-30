SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwContactsRoles]
AS
SELECT        dbo.ContactRoles.ContactRoleId, dbo.ContactRoles.ContactId, dbo.ContactRoles.RoleId, dbo.GeneralObjects.ObjectUniqueKey AS RoleCode, 
                         dbo.GeneralObjects.ObjectName AS RoleName, dbo.ContactRoles.ClinicId, dbo.ContactRoles.ClinicsFilter, dbo.ContactRoles.DictatorsFilter, 
                         dbo.ContactRoles.JobsFilter, dbo.ContactRoles.RoleStatus, ISNULL(dbo.Clinics.ClinicName, '') AS ClinicName, ISNULL(dbo.Clinics.ClinicCode, '') 
                         AS ClinicCode, dbo.Contacts.UserID
FROM            dbo.ContactRoles INNER JOIN
                         dbo.Clinics ON dbo.ContactRoles.ClinicId = dbo.Clinics.ClinicID INNER JOIN
                         dbo.GeneralObjects ON dbo.ContactRoles.RoleId = dbo.GeneralObjects.ObjectId INNER JOIN
                         dbo.Contacts ON dbo.ContactRoles.ContactId = dbo.Contacts.ContactId
WHERE        (NOT (dbo.ContactRoles.RoleStatus IN ('X', 'Y')))

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
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
         Begin Table = "ContactRoles"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 336
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clinics"
            Begin Extent = 
               Top = 162
               Left = 627
               Bottom = 270
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GeneralObjects"
            Begin Extent = 
               Top = 202
               Left = 304
               Bottom = 310
               Right = 469
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contacts"
            Begin Extent = 
               Top = 45
               Left = 958
               Bottom = 255
               Right = 1134
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
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
         Fi', 'SCHEMA', N'dbo', 'VIEW', N'vwContactsRoles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'lter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vwContactsRoles', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwContactsRoles', NULL, NULL
GO
