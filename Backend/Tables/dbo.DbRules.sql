CREATE TABLE [dbo].[DbRules]
(
[DbRuleId] [int] NOT NULL,
[DbRuleType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerId] [int] NOT NULL,
[TargetServerId] [int] NOT NULL,
[SourceName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeId] [int] NOT NULL,
[DbRuleIndex] [int] NOT NULL,
[DbRulePriority] [smallint] NOT NULL,
[DbRuleCondition] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StorageName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SecureParameters] [bit] NOT NULL,
[IdFieldName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IdTypeFieldName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LowerIdValue] [int] NOT NULL,
[UpperIdValue] [int] NOT NULL,
[CurrentIdValue] [int] NOT NULL CONSTRAINT [DF_DbRules_CurrentIdValue] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DbRules] ADD CONSTRAINT [PK_DbRules] PRIMARY KEY CLUSTERED  ([DbRuleId]) ON [PRIMARY]
GO
