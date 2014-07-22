SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwASPMembershipUsers]
AS
SELECT     dbo.aspnet_Membership.UserId, dbo.aspnet_Users.UserName, ISNULL(dbo.aspnet_Membership.Email, N'') AS Email, ISNULL(dbo.aspnet_Membership.Comment, N'')
                       AS ClinicName, dbo.UserIDMapping.UserIdOk
FROM         dbo.aspnet_Users INNER JOIN
                      dbo.aspnet_Membership ON dbo.aspnet_Users.UserId = dbo.aspnet_Membership.UserId AND 
                      dbo.aspnet_Users.ApplicationId = dbo.aspnet_Membership.ApplicationId INNER JOIN
                      dbo.UserIDMapping ON dbo.aspnet_Membership.UserId = dbo.UserIDMapping.UserId

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[7] 3) )"
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
               Top = 44
               Left = 417
               Bottom = 290
               Right = 587
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_UsersInRoles"
            Begin Extent = 
               Top = 26
               Left = 640
               Bottom = 232
               Right = 898
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_Roles"
            Begin Extent = 
               Top = 21
               Left = 1024
               Bottom = 248
               Right = 1193
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "aspnet_Membership"
            Begin Extent = 
               Top = 40
               Left = 167
               Bottom = 270
               Right = 393
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserIDMapping"
            Begin Extent = 
               Top = 124
               Left = 0
               Bottom = 274
               Right = 151
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
         Width = 1770
         Width = 2385
         Width = 4515
         Width = 3780
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column', 'SCHEMA', N'dbo', 'VIEW', N'vwASPMembershipUsers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' = 3405
         Alias = 2865
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwASPMembershipUsers', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwASPMembershipUsers', NULL, NULL
GO
