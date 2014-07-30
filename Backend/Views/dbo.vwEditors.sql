SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwEditors]
AS
SELECT     dbo.Editors.EditorIdOk, dbo.Editors.EditorID, dbo.Editors.EditorPwd, dbo.Editors.JobCount, dbo.Editors.JobMax, dbo.Editors.JobStat, dbo.Editors.AutoDownload, 
                      dbo.Editors.Managed, dbo.Editors.ManagedBy, dbo.Editors.ClinicID, dbo.Editors.EnableAudit, dbo.Editors.SignOff1, dbo.Editors.SignOff2, dbo.Editors.SignOff3, 
                      dbo.Editors.RoleID, dbo.Editors.FirstName, dbo.Editors.LastName, dbo.Editors.MI, dbo.Editors.EditorEMail, dbo.Editors.Type, 
                      CASE [Type] WHEN 10 THEN 'Editor' WHEN 20 THEN 'QA' ELSE 'Editor' END AS EditorType, dbo.Editors.IdleTime, dbo.Editors.EditorCompanyId, 
                      dbo.Companies.CompanyCode AS EditorCompanyCode, dbo.Companies.EditingWorkflowModelId, ISNULL(dbo.vwQueueWorkspaceEditors.QueueWorkspaceId, - 1) 
                      AS EditingWorkspaceId, dbo.Editors.EditorQAIDMatch, dbo.Contacts.ContactStatus AS EditorStatus
FROM         dbo.Editors INNER JOIN
                      dbo.Companies ON dbo.Editors.EditorCompanyId = dbo.Companies.CompanyId INNER JOIN
                      dbo.Contacts ON dbo.Editors.EditorIdOk = dbo.Contacts.ContactId AND dbo.Editors.EditorID = dbo.Contacts.UserID LEFT OUTER JOIN
                      dbo.vwQueueWorkspaceEditors ON dbo.Editors.EditorIdOk = dbo.vwQueueWorkspaceEditors.EditorId
WHERE     (dbo.Contacts.ContactType = 'E')
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[27] 2[12] 3) )"
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
         Begin Table = "Editors"
            Begin Extent = 
               Top = 40
               Left = 334
               Bottom = 278
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "Companies"
            Begin Extent = 
               Top = 218
               Left = 676
               Bottom = 405
               Right = 871
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contacts"
            Begin Extent = 
               Top = 8
               Left = 80
               Bottom = 307
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vwQueueWorkspaceEditors"
            Begin Extent = 
               Top = 85
               Left = 774
               Bottom = 193
               Right = 998
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
      Begin ColumnWidths = 29
         Width = 284
         Width = 1500
         Width = 1500
         Width = 10065
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
  ', 'SCHEMA', N'dbo', 'VIEW', N'vwEditors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'       Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5550
         Alias = 3555
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
', 'SCHEMA', N'dbo', 'VIEW', N'vwEditors', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vwEditors', NULL, NULL
GO
