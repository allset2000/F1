CREATE TABLE [dbo].[Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
<<<<<<< HEAD
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
=======
>>>>>>> release/CC.2
[ClinicID] [int] NOT NULL,
[LoginEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
<<<<<<< HEAD
[Salt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_Users_Deleted] DEFAULT ((0)),
[IsLockedOut] [bit] NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT ((0)),
[LastPasswordReset] [datetime] NULL,
[PasswordAttemptFailure] [int] NOT NULL CONSTRAINT [DF_Users_PasswordAttemptFailure] DEFAULT ((0)),
[LastFailedAttempt] [datetime] NULL,
[PWResetRequired] [bit] NOT NULL CONSTRAINT [DF_Users_DoResetPassword] DEFAULT ((0)),
[SecurityToken] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Users_SecurityToken] DEFAULT (''),
[LastLoginDate] [datetime] NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Users_LoginEmail] ON [dbo].[Users] ([LoginEmail]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [uc_UserName] UNIQUE NONCLUSTERED  ([UserName]) ON [PRIMARY]

ALTER TABLE [dbo].[Users] ADD 
CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID]) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Users_ClinicID] ON [dbo].[Users] ([ClinicID]) ON [PRIMARY]



=======
[Salt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Users_ClinicID] ON [dbo].[Users] ([ClinicID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_LoginEmail] ON [dbo].[Users] ([LoginEmail]) ON [PRIMARY]
>>>>>>> release/CC.2
GO
