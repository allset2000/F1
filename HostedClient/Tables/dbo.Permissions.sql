CREATE TABLE [dbo].[Permissions]
(
[PermissionID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permissions] ADD CONSTRAINT [PK_Permissions_1] PRIMARY KEY CLUSTERED  ([PermissionID]) ON [PRIMARY]
GO
