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
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [bliddle]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [bliddle]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [bliddle]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [cgulley]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [cgulley]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [cgulley]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [dhill]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [dhill]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [dhill]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [ezobel]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [ezobel]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [ezobel]
GRANT TAKE OWNERSHIP ON  [dbo].[ClinicsMessagesRules] TO [jsteidinger]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [jsteidinger]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [mmoscoso]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [mmoscoso]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [nwest]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [nwest]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [nwest]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [rspears]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [rspears]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [rspears]
GRANT SELECT ON  [dbo].[ClinicsMessagesRules] TO [rwilson]
GRANT INSERT ON  [dbo].[ClinicsMessagesRules] TO [rwilson]
GRANT UPDATE ON  [dbo].[ClinicsMessagesRules] TO [rwilson]
GO

ALTER TABLE [dbo].[ClinicsMessagesRules] ADD CONSTRAINT [PK_CRMessageRules] PRIMARY KEY CLUSTERED  ([MessageRuleId]) ON [PRIMARY]
GO
