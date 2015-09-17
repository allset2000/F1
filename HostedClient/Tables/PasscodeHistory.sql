USE [EntradaHostedClient]
GO

/****** Object:  Table [dbo].[PasscodeHistory]    Script Date: 8/17/2015 4:24:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PasscodeHistory]
(
[PwdId] [int] NOT NULL IDENTITY(1, 1),
[PassCode] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_PasscodeHistory_IsActive] DEFAULT ((1)),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_PasscodeHistory_DateCreated] DEFAULT (getdate()),
[UserId] [int] NOT NULL,
[Salt] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PasswordIterationNumber] [int] NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[PasscodeHistory] ADD 
CONSTRAINT [PK_PasscodeHistory] PRIMARY KEY CLUSTERED  ([PwdId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'test', N'test value', 'SCHEMA', N'dbo', 'TABLE', N'PasscodeHistory', NULL, NULL
GO


SET ANSI_PADDING OFF
GO
