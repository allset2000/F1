CREATE TABLE [dbo].[RulesDictations]
(
[RuleID] [smallint] NOT NULL,
[ActionID] [int] NOT NULL,
[TemplateID] [smallint] NOT NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTypeID] [smallint] NULL,
[DictationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[RulesDictations] ADD 
CONSTRAINT [PK_Rules_Templates] PRIMARY KEY CLUSTERED  ([RuleID], [ActionID], [TemplateID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RulesDictations] ADD CONSTRAINT [FK_Rules_Templates_Rules_Jobs] FOREIGN KEY ([RuleID], [ActionID]) REFERENCES [dbo].[RulesJobs] ([RuleID], [ActionID])
GO
