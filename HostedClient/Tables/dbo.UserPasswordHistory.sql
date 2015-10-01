USE [EntradaHostedClient]
GO

/****** Object:  Table [dbo].[UserPasswordHistory]    Script Date: 10/1/2015 10:43:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UserPasswordHistory](
	[PasswordHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Password] [varchar](300) NOT NULL,
	[Salt] [varchar](300) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_UserPasswordHistory_IsActive]  DEFAULT ((1)),
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_UserPasswordHistory_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_PasswordHistoryId] PRIMARY KEY CLUSTERED 
(
	[PasswordHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[UserPasswordHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_UserPasswordHistory_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[UserPasswordHistory] CHECK CONSTRAINT [FK_UserPasswordHistory_Users]
GO


