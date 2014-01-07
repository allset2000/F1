CREATE TABLE [dbo].[AccountManagers]
(
[AccountManagerID] [smallint] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountManagers] ADD CONSTRAINT [PK_AccountManagers] PRIMARY KEY CLUSTERED  ([AccountManagerID]) ON [PRIMARY]
GO
