CREATE TABLE [dbo].[WorkflowRules]
(
[WorkflowRuleId] [int] NOT NULL,
[WorkflowModelId] [int] NOT NULL,
[EventTag] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromStateId] [int] NOT NULL,
[ToStateId] [int] NOT NULL,
[Precondition] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BeforeTransition] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AfterTransition] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationOrder] [int] NOT NULL,
[PostedById] [int] NOT NULL,
[PostingTime] [smalldatetime] NOT NULL,
[WorkflowRuleStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowRules] ADD CONSTRAINT [PK_WorkflowRules] PRIMARY KEY CLUSTERED  ([WorkflowRuleId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code that executes immediately after the application of the workflow state change.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'AfterTransition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An order integer for specify the order application of the wotkflow transition', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'ApplicationOrder'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code that executes immediately before the application of the workflow state change.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'BeforeTransition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id key in GeneralObjects table using ''WorkflowEvent'' as ObjectType.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'EventTag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id key in GeneralObjects table using ''WorkflowState'' as ObjectType.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'FromStateId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id key in Contacts table.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'PostedById'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTime when the rule was appended or modified', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'PostingTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Precondition necessary for the application of the transition rule.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'Precondition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id key in GeneralObjects table using ''WorkflowState'' as ObjectType.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'ToStateId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id key in GeneralObjects table using ''WorkflowDefinition'' as ObjectType.', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'WorkflowModelId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A = Active, I = Inactive, X = Deleted', 'SCHEMA', N'dbo', 'TABLE', N'WorkflowRules', 'COLUMN', N'WorkflowRuleStatus'
GO
