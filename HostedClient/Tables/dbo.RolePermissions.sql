CREATE TABLE [dbo].[RolePermissions]
(
[RoleID] [int] NOT NULL,
[PermissionID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RolePermissions] ADD CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED  ([RoleID], [PermissionID]) ON [PRIMARY]
GO
