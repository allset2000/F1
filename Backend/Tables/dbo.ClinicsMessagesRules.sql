CREATE TABLE [dbo].[ClinicsMessagesRules]
(
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
[NoStatJobFrequency] [decimal] (8, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicsMessagesRules] ADD CONSTRAINT [PK_CRMessageRules] PRIMARY KEY CLUSTERED  ([MessageRuleId]) ON [PRIMARY]
GO
