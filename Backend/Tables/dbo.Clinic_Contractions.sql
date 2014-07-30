CREATE TABLE [dbo].[Clinic_Contractions]
(
[ClinicID] [smallint] NOT NULL,
[Contraction] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContractionText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinic_Contractions] ADD CONSTRAINT [PK_Clinic_Contractions] PRIMARY KEY CLUSTERED  ([ClinicID], [Contraction]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinic_Contractions] ADD CONSTRAINT [FK_Clinic_Contractions_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
