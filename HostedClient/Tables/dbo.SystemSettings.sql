CREATE TABLE [dbo].[SystemSettings]
(
[SystemSettingsID] [smallint] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[GenericPatientID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemSettings] ADD CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED  ([SystemSettingsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SystemSettings_ClinicID] ON [dbo].[SystemSettings] ([ClinicID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemSettings] WITH NOCHECK ADD CONSTRAINT [FK_SystemSettings_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SystemSettings] ADD CONSTRAINT [FK_SystemSettings_Patients] FOREIGN KEY ([GenericPatientID]) REFERENCES [dbo].[Patients] ([PatientID])
GO
