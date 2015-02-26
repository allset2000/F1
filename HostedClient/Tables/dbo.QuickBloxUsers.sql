CREATE TABLE [dbo].[QuickBloxUsers]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[QuickBloxUserID] [int] NOT NULL,
[Login] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QuickBloxUsers] ADD CONSTRAINT [PK_QuickBloxUsers] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QuickBloxUsers] ADD CONSTRAINT [FK_QuickBloxUsers_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
