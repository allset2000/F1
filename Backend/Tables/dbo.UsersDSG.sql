CREATE TABLE [dbo].[UsersDSG]
(
[UserId] [int] NOT NULL IDENTITY(1, 1),
[Username] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UsersDSG] ADD CONSTRAINT [PK_UsersDSG] PRIMARY KEY CLUSTERED  ([UserId]) ON [PRIMARY]
GO
