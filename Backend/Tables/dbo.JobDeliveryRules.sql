CREATE TABLE [dbo].[JobDeliveryRules]
(
[RuleID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Method] [smallint] NOT NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AvoidRedelivery] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobDeliveryRules] ADD CONSTRAINT [PK_JobDeliveryRules] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobDeliveryRules] ADD CONSTRAINT [FK_JobDeliveryRules_JobsDeliveryMethods] FOREIGN KEY ([Method]) REFERENCES [dbo].[JobsDeliveryMethods] ([JobDeliveryID])
GO
