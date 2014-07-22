CREATE TABLE [dbo].[aspnet_Roles]
(
[ApplicationId] [uniqueidentifier] NOT NULL,
[RoleId] [uniqueidentifier] NOT NULL CONSTRAINT [DF__aspnet_Ro__RoleI__44FF419A] DEFAULT (newid()),
[RoleName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoweredRoleName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_Roles] ADD CONSTRAINT [PK__aspnet_R__8AFACE1B4222D4EF] PRIMARY KEY NONCLUSTERED  ([RoleId]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [aspnet_Roles_index1] ON [dbo].[aspnet_Roles] ([ApplicationId], [LoweredRoleName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[aspnet_Roles] ADD CONSTRAINT [FK__aspnet_Ro__Appli__440B1D61] FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
