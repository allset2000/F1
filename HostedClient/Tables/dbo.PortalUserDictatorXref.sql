CREATE TABLE [dbo].[PortalUserDictatorXref]
(
[PortalUserDictatorXrefId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DictatorId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_PortalUserDictatorXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PortalUserDictatorXref] ADD CONSTRAINT [PK_PortalUserDictatorXref] PRIMARY KEY CLUSTERED  ([PortalUserDictatorXrefId]) ON [PRIMARY]
GO
