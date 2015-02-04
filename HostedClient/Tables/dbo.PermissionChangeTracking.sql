CREATE TABLE [dbo].[PermissionChangeTracking]
(
[PermissionChangeTrackingId] [int] NOT NULL IDENTITY(1, 1),
[AddPermissions] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DelPermissions] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AppPermissions] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateChanged] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermissionChangeTracking] ADD CONSTRAINT [PK_PermissionChangeTracking] PRIMARY KEY CLUSTERED  ([PermissionChangeTrackingId]) ON [PRIMARY]
GO
