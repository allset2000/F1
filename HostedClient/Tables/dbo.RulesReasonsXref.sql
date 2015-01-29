CREATE TABLE [dbo].[RulesReasonsXref]
(
[RuleID] [smallint] NOT NULL,
[ActionID] [smallint] NOT NULL IDENTITY(1, 1),
[ReasonID] [smallint] NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_RulesReasonsXref_ReasonID_includes] ON [dbo].[RulesReasonsXref] ([ReasonID]) INCLUDE ([RuleID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [PK_Rules_ReasonXref] PRIMARY KEY CLUSTERED  ([RuleID], [ActionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [FK_Rulesreasons_ReasonsXref_Rules] FOREIGN KEY ([ReasonID]) REFERENCES [dbo].[RulesReasons] ([ID])
GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [FK_Rules_ReasonXref_Rules] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rules] ([RuleID])
GO
