SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryUsersAndRoles]
AS
SELECT     TOP (1000) dbo.aspnet_Users.UserName, dbo.aspnet_Roles.RoleName, dbo.aspnet_Membership.Email, dbo.aspnet_Membership.LoweredEmail
FROM         dbo.aspnet_Users INNER JOIN
                      dbo.aspnet_UsersInRoles ON dbo.aspnet_Users.UserId = dbo.aspnet_UsersInRoles.UserId INNER JOIN
                      dbo.aspnet_Roles ON dbo.aspnet_UsersInRoles.RoleId = dbo.aspnet_Roles.RoleId INNER JOIN
                      dbo.aspnet_Membership ON dbo.aspnet_Users.UserId = dbo.aspnet_Membership.UserId
ORDER BY dbo.aspnet_Users.UserName
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[9] 3) )"
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
         Begin Table = "aspnet_Users"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 236
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "aspnet_UsersInRoles"
            Begin Extent = 
               Top = 6
               Left = 274
               Bottom = 95
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_Roles"
            Begin Extent = 
               Top = 96
               Left = 274
               Bottom = 215
               Right = 472
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_Membership"
            Begin Extent = 
               Top = 6
               Left = 510
               Bottom = 192
               Right = 810
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
     ', 'SCHEMA', N'dbo', 'VIEW', N'qryUsersAndRoles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'qryUsersAndRoles', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'qryUsersAndRoles', NULL, NULL
GO
