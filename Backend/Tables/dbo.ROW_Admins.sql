CREATE TABLE [dbo].[ROW_Admins]
(
[Admin_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Admin_Password] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_Admins] ADD CONSTRAINT [PK_Admins] PRIMARY KEY CLUSTERED  ([Admin_ID]) ON [PRIMARY]
GO
