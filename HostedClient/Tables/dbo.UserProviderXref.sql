CREATE TABLE [dbo].[UserProviderXref]
(
[UserProviderXref] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserProviderXref_IsDeleted] DEFAULT ((0)),
[BackenddictatorID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[UserProviderXref] ADD
CONSTRAINT [FK_UserProviderXref_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserID])
GO
