CREATE TABLE [dbo].[ClinicsAutoText]
(
[ClinicID] [smallint] NOT NULL,
[AutoText_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AutoText_Content] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicsAutoText] ADD CONSTRAINT [PK_ClinicsAutoText] PRIMARY KEY CLUSTERED  ([ClinicID], [AutoText_Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicsAutoText] ADD CONSTRAINT [FK_ClinicsAutoText_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
