CREATE TABLE [dbo].[ClinicMessageRuleJobtypes]
(
[MessageRuleId] [int] NOT NULL,
[Jobtype] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicMessageRuleJobtypes] ADD CONSTRAINT [FK_ClinicMessageRuleJobtypes_ClinicsMessagesRules] FOREIGN KEY ([MessageRuleId]) REFERENCES [dbo].[ClinicsMessagesRules] ([MessageRuleId])
GO
