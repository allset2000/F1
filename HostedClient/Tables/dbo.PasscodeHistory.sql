CREATE TABLE [dbo].[PasscodeHistory](
	[PwdId] [int] IDENTITY(1,1) NOT NULL,
	[PassCode] [varchar](300) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_PasscodeHistory_IsActive]  DEFAULT ((1)),
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_PasscodeHistory_DateCreated]  DEFAULT (getdate()),
	[UserId] [int] NOT NULL,
	[Salt] [varchar](500) NOT NULL,
	[PasswordIterationNumber] [int] NOT NULL,
 CONSTRAINT [PK_PasscodeHistory] PRIMARY KEY CLUSTERED 
(
	[PwdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO