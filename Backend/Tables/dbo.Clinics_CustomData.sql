CREATE TABLE [dbo].[Clinics_CustomData]
(
[ClinicID] [smallint] NOT NULL,
[Field] [smallint] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinics_CustomData] ADD CONSTRAINT [PK_Clinics_CustomData] PRIMARY KEY CLUSTERED  ([ClinicID], [Field]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinics_CustomData] ADD CONSTRAINT [FK_Clinics_CustomData_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
