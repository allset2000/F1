CREATE TABLE [dbo].[Schedules]
(
[ScheduleID] [bigint] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[AppointmentDate] [datetime] NOT NULL,
[PatientID] [int] NOT NULL,
[AppointmentID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_AppointmentID] DEFAULT (''),
[EHREncounterID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Schedules_EncounterID] DEFAULT (''),
[Attending] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Schedules_Attending] DEFAULT (''),
[LocationID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_LocationID] DEFAULT (''),
[LocationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_LocationName] DEFAULT (''),
[ReasonID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_ReasonID] DEFAULT (''),
[ReasonName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_ReasonName] DEFAULT (''),
[ResourceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_ResourceID] DEFAULT (''),
[ResourceName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Schedules_ResourceName] DEFAULT (''),
[Status] [smallint] NOT NULL,
[AdditionalData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowProcessed] [int] NOT NULL CONSTRAINT [DF_Schedules_RowProcessed] DEFAULT ((0)),
[ReferringID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferringName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingFirst] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttendingLast] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangedOn] [datetime] NULL CONSTRAINT [DF_Schedules_ChangedOn] DEFAULT (getdate()),
[Type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Schedules__Type__544C7222] DEFAULT ('S'),
[CreateDate] [datetime] NULL,
[UpdatedDateInUTC] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Schedules] ADD CONSTRAINT [PK_Schedules] PRIMARY KEY CLUSTERED  ([ScheduleID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Schedules_1] ON [dbo].[Schedules] ([AppointmentID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Schedules] ON [dbo].[Schedules] ([ClinicID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Schedules_ClinicIDAttending] ON [dbo].[Schedules] ([ClinicID], [Attending], [AttendingLast], [AttendingFirst]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Schedule_ClinIDResIDResNm] ON [dbo].[Schedules] ([ClinicID], [ResourceID], [ResourceName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LocationID] ON [dbo].[Schedules] ([LocationID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReasonID] ON [dbo].[Schedules] ([ReasonID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ResourceID] ON [dbo].[Schedules] ([ResourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RowProcessed_ClinicID_AppointmentID_WithINC_ScheduleID_AppointmentDate] ON [dbo].[Schedules] ([RowProcessed], [ClinicID], [AppointmentID]) INCLUDE ([AppointmentDate], [ScheduleID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Schedules] ADD CONSTRAINT [FK_Schedules_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
