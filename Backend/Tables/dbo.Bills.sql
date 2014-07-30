CREATE TABLE [dbo].[Bills]
(
[BillId] [int] NOT NULL,
[ClinicId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
[SendToEMail] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SalesTerm] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PeriodStart] [smalldatetime] NOT NULL,
[PeriodEnd] [smalldatetime] NOT NULL,
[IssueDate] [smalldatetime] NOT NULL,
[DueDate] [smalldatetime] NOT NULL,
[BillStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Bills] ADD CONSTRAINT [PK_Bills] PRIMARY KEY CLUSTERED  ([BillId]) ON [PRIMARY]
GO
