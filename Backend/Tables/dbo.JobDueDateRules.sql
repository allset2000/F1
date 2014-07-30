CREATE TABLE [dbo].[JobDueDateRules]
(
[DueDateRuleId] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplyToStat] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DueMinutes] [int] NOT NULL,
[RuleApplicationTime] [datetime] NOT NULL,
[RuleStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobDueDateRules] ADD CONSTRAINT [PK_JobDueDateRules] PRIMARY KEY CLUSTERED  ([DueDateRuleId]) ON [PRIMARY]
GO
