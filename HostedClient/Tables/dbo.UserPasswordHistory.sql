CREATE TABLE [dbo].[UserPasswordHistory]
(
[PasswordHistoryId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[Password] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserPasswordHistory_IsActive] DEFAULT ((1)),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_UserPasswordHistory_DateCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPasswordHistory] ADD CONSTRAINT [PK_PasswordHistoryId] PRIMARY KEY CLUSTERED  ([PasswordHistoryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPasswordHistory] ADD CONSTRAINT [FK_UserPasswordHistory_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserID])
GO
