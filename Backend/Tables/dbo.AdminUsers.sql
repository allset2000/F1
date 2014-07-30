CREATE TABLE [dbo].[AdminUsers]
(
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminUsers] ADD CONSTRAINT [PK_AdminUsers] PRIMARY KEY CLUSTERED  ([Username]) ON [PRIMARY]
GO
