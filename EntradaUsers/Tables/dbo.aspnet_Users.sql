CREATE TABLE [dbo].[aspnet_Users]
(
[ApplicationId] [uniqueidentifier] NOT NULL,
[UserId] [uniqueidentifier] NOT NULL CONSTRAINT [DF__aspnet_Us__UserI__0EA330E9] DEFAULT (newid()),
[UserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoweredUserName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MobileAlias] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__aspnet_Us__Mobil__0F975522] DEFAULT (NULL),
[IsAnonymous] [bit] NOT NULL CONSTRAINT [DF__aspnet_Us__IsAno__108B795B] DEFAULT ((0)),
[LastActivityDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD CONSTRAINT [PK__aspnet_U__1788CC4D0BC6C43E] PRIMARY KEY NONCLUSTERED  ([UserId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [aspnet_Users_Index2] ON [dbo].[aspnet_Users] ([ApplicationId], [LastActivityDate]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Users_Index] ON [dbo].[aspnet_Users] ([ApplicationId], [LoweredUserName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_Users] ADD CONSTRAINT [FK__aspnet_Us__Appli__0DAF0CB0] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
