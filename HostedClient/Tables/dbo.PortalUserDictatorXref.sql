CREATE TABLE [dbo].[PortalUserDictatorXref]
(
[PortalUserDictatorXrefId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DictatorId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_PortalUserDictatorXref_IsDeleted] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[PortalUserDictatorXref] ADD
CONSTRAINT [FK_PortalUserDictatorXref_Dictators] FOREIGN KEY ([DictatorId]) REFERENCES [dbo].[Dictators] ([DictatorID])
ALTER TABLE [dbo].[PortalUserDictatorXref] ADD
CONSTRAINT [FK_PortalUserDictatorXref_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[PortalUserDictatorXref] ADD CONSTRAINT [PK_PortalUserDictatorXref] PRIMARY KEY CLUSTERED  ([PortalUserDictatorXrefId]) ON [PRIMARY]
GO
