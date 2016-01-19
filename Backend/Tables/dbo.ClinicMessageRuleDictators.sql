CREATE TABLE [dbo].[ClinicMessageRuleDictators]
(
[MessageRuleId] [int] NOT NULL,
[DictatorId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicMessageRuleDictators] ADD CONSTRAINT [FK_ClinicMessageRuleDictators_ClinicsMessagesRules] FOREIGN KEY ([MessageRuleId]) REFERENCES [dbo].[ClinicsMessagesRules] ([MessageRuleId])
GO
