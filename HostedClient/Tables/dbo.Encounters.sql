CREATE TABLE [dbo].[Encounters]
(
[EncounterID] [bigint] NOT NULL IDENTITY(1, 1),
[AppointmentDate] [datetime] NOT NULL,
[PatientID] [int] NOT NULL,
[ScheduleID] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Encounters] ADD CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED  ([EncounterID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Encounters_AppointmentDate] ON [dbo].[Encounters] ([AppointmentDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FK_Schedules_ScheduleID] ON [dbo].[Encounters] ([ScheduleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Encounters] ADD CONSTRAINT [FK_Appointments_Patients] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patients] ([PatientID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Encounters] ADD CONSTRAINT [FK_Encounters_Schedules] FOREIGN KEY ([ScheduleID]) REFERENCES [dbo].[Schedules] ([ScheduleID])
GO
GRANT VIEW DEFINITION ON  [dbo].[Encounters] TO [mmoscoso]
GRANT SELECT ON  [dbo].[Encounters] TO [mmoscoso]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encounter Date', 'SCHEMA', N'dbo', 'TABLE', N'Encounters', 'COLUMN', N'AppointmentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal ID', 'SCHEMA', N'dbo', 'TABLE', N'Encounters', 'COLUMN', N'EncounterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encounter Patient', 'SCHEMA', N'dbo', 'TABLE', N'Encounters', 'COLUMN', N'PatientID'
GO
