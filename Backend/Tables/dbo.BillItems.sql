CREATE TABLE [dbo].[BillItems]
(
[BillItemId] [int] NOT NULL,
[BillId] [int] NOT NULL,
[BillingRuleId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[JobId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BillItemDate] [smalldatetime] NOT NULL,
[UnitPrice] [decimal] (9, 4) NOT NULL,
[Qty] [decimal] (9, 6) NOT NULL,
[SubTotal] [decimal] (9, 2) NOT NULL,
[Tax] [decimal] (9, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BillItems] ADD CONSTRAINT [PK_BillItems] PRIMARY KEY CLUSTERED  ([BillItemId]) ON [PRIMARY]
GO
