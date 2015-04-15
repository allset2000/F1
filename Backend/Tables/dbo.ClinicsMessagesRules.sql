CREATE TABLE [dbo].[ClinicsMessagesRules](
[MessageRuleId] [int] NOT NULL,
[MessageTypeId] [int] NOT NULL,
[ClinicID] [smallint] NOT NULL,
[LocationID] [smallint] NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatJobSubjectPattern] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatJobContentPattern] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NoStatJobSubjectPattern] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NoStatJobContentPattern] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SendTo] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatJobFrequency] [decimal] (8, 2) NOT NULL,
[NoStatJobFrequency] [decimal](8, 2) NOT NULL,
[UserID] [int] NULL,
[NotificationTypeID] [int] NULL,
 CONSTRAINT [PK_CRMessageRules] PRIMARY KEY CLUSTERED 
(
	[MessageRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [bliddle] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [bliddle] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [bliddle] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [cgulley] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [cgulley] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [cgulley] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [dhill] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [dhill] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [dhill] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [ezobel] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [ezobel] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [ezobel] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [jsteidinger] AS [dbo]
GO
GRANT TAKE OWNERSHIP ON [dbo].[ClinicsMessagesRules] TO [jsteidinger] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [mmoscoso] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [mmoscoso] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [mmoscoso] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [nwest] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [nwest] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [nwest] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [rspears] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [rspears] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [rspears] AS [dbo]
GO
GRANT INSERT ON [dbo].[ClinicsMessagesRules] TO [rwilson] AS [dbo]
GO
GRANT SELECT ON [dbo].[ClinicsMessagesRules] TO [rwilson] AS [dbo]
GO
GRANT UPDATE ON [dbo].[ClinicsMessagesRules] TO [rwilson] AS [dbo]
GO
