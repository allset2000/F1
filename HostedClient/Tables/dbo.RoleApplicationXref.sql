CREATE TABLE [dbo].[RoleApplicationXref]
(
[RoleApplicationXrefId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[ApplicationId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserApplicationXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoleApplicationXref] ADD CONSTRAINT [PK_UserApplicationXref] PRIMARY KEY CLUSTERED  ([RoleApplicationXrefId]) ON [PRIMARY]
GO
