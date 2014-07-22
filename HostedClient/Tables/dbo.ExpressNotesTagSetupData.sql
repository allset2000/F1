CREATE TABLE [dbo].[ExpressNotesTagSetupData]
(
[TagSetupID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NULL,
[EHRVendorID] [smallint] NULL,
[DocumentID] [smallint] NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Item] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExpressNotesTagSetupData] ADD CONSTRAINT [PK_ExpressNotesSetupTagData] PRIMARY KEY CLUSTERED  ([TagSetupID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExpressNotesTagSetupData] ADD CONSTRAINT [FK_ExpressNotesTagSetupData_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[ExpressNotesTagSetupData] ADD CONSTRAINT [FK_ExpressNotesTagSetupData_EHRVendors] FOREIGN KEY ([EHRVendorID]) REFERENCES [dbo].[EHRVendors] ([EHRVendorID])
GO
