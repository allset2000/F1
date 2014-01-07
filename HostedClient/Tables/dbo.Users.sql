CREATE TABLE [dbo].[Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [int] NOT NULL,
[LoginEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Users_ClinicID] ON [dbo].[Users] ([ClinicID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_LoginEmail] ON [dbo].[Users] ([LoginEmail]) ON [PRIMARY]
GO
