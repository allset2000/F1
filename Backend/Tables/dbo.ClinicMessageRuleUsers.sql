CREATE TABLE [dbo].[ClinicMessageRuleUsers]
(
[MessageRuleId] [int] NOT NULL,
[UserId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicMessageRuleUsers] ADD CONSTRAINT [FK_ClinicMessageRuleUsers_ClinicsMessagesRules] FOREIGN KEY ([MessageRuleId]) REFERENCES [dbo].[ClinicsMessagesRules] ([MessageRuleId])
GO
