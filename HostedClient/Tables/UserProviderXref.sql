USE [EntradaHostedClient]
GO

/****** Object:  Table [dbo].[UserProviderXref]    Script Date: 8/17/2015 11:31:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[UserProviderXref](
	[UserProviderXref] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[ProviderId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_UserProviderXref_IsDeleted]  DEFAULT ((0)),
	[BackenddictatorID] [varchar](500) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


