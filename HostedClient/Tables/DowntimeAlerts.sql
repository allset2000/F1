USE [EntradaHostedClient]
GO

/****** Object:  Table [dbo].[DowntimeAlerts]    Script Date: 8/17/2015 11:33:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DowntimeAlerts](
	[DowntimeAlertId] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ApplicationId] [int] NOT NULL,
 CONSTRAINT [PK_DowntimeAlerts] PRIMARY KEY CLUSTERED 
(
	[DowntimeAlertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DowntimeAlerts]  WITH CHECK ADD  CONSTRAINT [FK_DowntimeAlerts_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO

ALTER TABLE [dbo].[DowntimeAlerts] CHECK CONSTRAINT [FK_DowntimeAlerts_Applications]
GO


