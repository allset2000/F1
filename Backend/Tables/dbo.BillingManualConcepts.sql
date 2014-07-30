CREATE TABLE [dbo].[BillingManualConcepts]
(
[BillingManualItemId] [int] NOT NULL IDENTITY(1, 1),
[BillingRuleId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[JobId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConceptQty] [decimal] (9, 6) NOT NULL,
[ApplyOn] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillingManualConcepts] ADD CONSTRAINT [PK_BillingManualConcepts] PRIMARY KEY CLUSTERED  ([BillingManualItemId]) ON [PRIMARY]
GO
