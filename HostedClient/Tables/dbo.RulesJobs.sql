CREATE TABLE [dbo].[RulesJobs]
(
[RuleID] [smallint] NOT NULL,
[ActionID] [smallint] NOT NULL IDENTITY(1, 1),
[DictatorID] [int] NULL,
[QueueID] [smallint] NULL,
[ProviderID] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesJobs] ADD CONSTRAINT [PK_Rules_Jobs] PRIMARY KEY CLUSTERED  ([RuleID], [ActionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesJobs] ADD CONSTRAINT [FK_Rules_Jobs_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
GO
ALTER TABLE [dbo].[RulesJobs] ADD CONSTRAINT [FK_Rules_Jobs_Rules_Definition] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rules] ([RuleID]) ON DELETE CASCADE
GO
GRANT VIEW DEFINITION ON  [dbo].[RulesJobs] TO [mmoscoso]
GRANT SELECT ON  [dbo].[RulesJobs] TO [mmoscoso]
GO
