USE [EntradaHostedClient]
GO

/****** Object:  Table [dbo].[PasscodeHistory]    Script Date: 8/17/2015 4:24:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PasscodeHistory](
	[PwdId] [int] IDENTITY(1,1) NOT NULL,
	[PassCode] [varchar](300) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_PasscodeHistory_IsActive]  DEFAULT ((1)),
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_PasscodeHistory_DateCreated]  DEFAULT (getdate()),
	[UserId] [int] NOT NULL,
	[Salt] [varchar](500) NOT NULL,
 CONSTRAINT [PK_PasscodeHistory] PRIMARY KEY CLUSTERED 
(
	[PwdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


