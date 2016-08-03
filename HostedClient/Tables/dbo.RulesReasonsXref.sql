CREATE TABLE [dbo].[RulesReasonsXref]
(
[RuleID] [int] NOT NULL,
[ActionID] [int] NOT NULL IDENTITY(1, 1),
[ReasonID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [PK_Rules_ReasonXref] PRIMARY KEY CLUSTERED  ([RuleID], [ActionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RulesReasonsXREF_ReasonID] ON [dbo].[RulesReasonsXref] ([ReasonID]) INCLUDE ([RuleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [FK_Rules_ReasonXref_Rules] FOREIGN KEY ([RuleID]) REFERENCES [dbo].[Rules] ([RuleID])
GO
ALTER TABLE [dbo].[RulesReasonsXref] ADD CONSTRAINT [FK_Rulesreasons_ReasonsXref_Rules] FOREIGN KEY ([ReasonID]) REFERENCES [dbo].[RulesReasons] ([ID])
GO
