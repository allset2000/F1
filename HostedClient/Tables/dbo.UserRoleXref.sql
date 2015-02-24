CREATE TABLE [dbo].[UserRoleXref]
(
[UserRoleXrefID] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserRoleXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserRoleXref] ADD CONSTRAINT [PK_UserRoleXref] PRIMARY KEY CLUSTERED  ([UserRoleXrefID]) ON [PRIMARY]
GO
