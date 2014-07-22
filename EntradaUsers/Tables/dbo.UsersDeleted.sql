CREATE TABLE [dbo].[UsersDeleted]
(
[Username] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeletedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
