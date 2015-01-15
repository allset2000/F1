CREATE TABLE [dbo].[RolePermissionXref]
(
[RolePermissionXrefId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[PermissionId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_RolePermissionXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RolePermissionXref] ADD CONSTRAINT [PK_RolePermissionXref] PRIMARY KEY CLUSTERED  ([RolePermissionXrefId]) ON [PRIMARY]
GO
