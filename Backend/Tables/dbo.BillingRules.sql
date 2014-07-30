CREATE TABLE [dbo].[BillingRules]
(
[BillingRuleId] [int] NOT NULL IDENTITY(1, 1),
[BillingConceptId] [int] NOT NULL,
[BillingRuleCode] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BillingRuleName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[JobType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StatJob] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaxRate] [decimal] (5, 3) NOT NULL,
[RuleConfig] [varchar] (4096) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDate] [smalldatetime] NOT NULL,
[EndDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillingRules] ADD CONSTRAINT [PK_BillingRulesApplication] PRIMARY KEY CLUSTERED  ([BillingRuleId]) ON [PRIMARY]
GO
