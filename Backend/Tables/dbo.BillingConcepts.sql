CREATE TABLE [dbo].[BillingConcepts]
(
[BillingConceptId] [int] NOT NULL IDENTITY(1, 1),
[ConceptCode] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConceptName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CalculationSource] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CalculationMethod] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BillingDetailMode] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QtyUnitType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConceptConfig] [varchar] (4096) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillingConcepts] ADD CONSTRAINT [PK_BillingRules] PRIMARY KEY CLUSTERED  ([BillingConceptId]) ON [PRIMARY]
GO
