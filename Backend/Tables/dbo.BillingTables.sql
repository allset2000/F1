CREATE TABLE [dbo].[BillingTables]
(
[BillingTableItemId] [int] NOT NULL IDENTITY(1, 1),
[BillingConceptId] [int] NOT NULL,
[BillingRuleId] [int] NOT NULL,
[ItemType] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FromQty] [int] NOT NULL,
[ToQty] [int] NOT NULL,
[UnitPrice] [decimal] (9, 4) NOT NULL,
[StartDate] [smalldatetime] NOT NULL,
[EndDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillingTables] ADD CONSTRAINT [PK_BillingTables] PRIMARY KEY CLUSTERED  ([BillingTableItemId]) ON [PRIMARY]
GO
