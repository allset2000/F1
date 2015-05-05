CREATE TABLE [dbo].[SchedulesTracking]
(
[SchedulesTrackingID] [bigint] NOT NULL IDENTITY(1, 1),
[ScheduleID] [bigint] NOT NULL,
[ClinicID] [smallint] NOT NULL,
[AppointmentDate] [datetime] NOT NULL,
[PatientID] [int] NOT NULL,
[AppointmentID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EncounterID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attending] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LocationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReasonID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReasonName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResourceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResourceName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NOT NULL,
[AdditionalData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangedOn] [datetime] NOT NULL,
[ChangedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReferringID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferringName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingFirst] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingLast] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SchedulesT__Type__5540965B] DEFAULT ('S')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [ix_Schedulestracking_ClinicID] ON [dbo].[SchedulesTracking] ([ClinicID]) INCLUDE ([ChangedOn]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_SchedulesTracking_ChangedOn] ON [dbo].[SchedulesTracking] ([ChangedOn] DESC) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SchedulesTracking] ADD CONSTRAINT [PK_EncountersTracking] PRIMARY KEY CLUSTERED  ([SchedulesTrackingID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SchedulesTracking] ON [dbo].[SchedulesTracking] ([ScheduleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SchedulesTracking] ADD CONSTRAINT [FK_SchedulesTracking_Schedules] FOREIGN KEY ([ScheduleID]) REFERENCES [dbo].[Schedules] ([ScheduleID])
GO
