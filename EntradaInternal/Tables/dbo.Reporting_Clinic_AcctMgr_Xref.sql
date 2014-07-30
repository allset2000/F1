CREATE TABLE [dbo].[Reporting_Clinic_AcctMgr_Xref]
(
[XrefID] [int] NOT NULL IDENTITY(1, 1),
[ClinicCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicID] [int] NOT NULL,
[AcctManagerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reporting_Clinic_AcctMgr_Xref] ADD CONSTRAINT [PK__Reportin__C40934581975C517] PRIMARY KEY CLUSTERED  ([XrefID]) ON [PRIMARY]
GO
