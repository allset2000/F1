CREATE TABLE [dbo].[Reporting_MasterBilling]
(
[ClinicCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LineCharge] [decimal] (5, 3) NULL,
[TechLineCharge] [decimal] (5, 3) NULL,
[EditingLineCharge] [decimal] (5, 3) NULL,
[PerDictatorCharge] [int] NULL,
[JobCharge] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reporting_MasterBilling] ADD CONSTRAINT [PK__Reportin__996128CB3C89F72A] PRIMARY KEY CLUSTERED  ([ClinicCode]) ON [PRIMARY]
GO
