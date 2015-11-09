CREATE TABLE [dbo].[RoleApplicationXref]
(
[RoleApplicationXrefId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[ApplicationId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserApplicationXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[RoleApplicationXref] ADD
CONSTRAINT [FK_RoleApplicationXref_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Applications] ([ApplicationId])
ALTER TABLE [dbo].[RoleApplicationXref] ADD
CONSTRAINT [FK_RoleApplicationXref_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[RoleApplicationXref] ADD CONSTRAINT [PK_UserApplicationXref] PRIMARY KEY CLUSTERED  ([RoleApplicationXrefId]) ON [PRIMARY]
GO
