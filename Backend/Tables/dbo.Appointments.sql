CREATE TABLE [dbo].[Appointments]
(
[AppointmentId] [int] NOT NULL,
[ClinicID] [smallint] NOT NULL,
[LocationID] [smallint] NOT NULL,
[AttendingDictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AppointmentDate] [datetime] NOT NULL,
[AppointmentTime] [datetime] NOT NULL,
[ReasonTag] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReasonText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DocumentId] [int] NOT NULL CONSTRAINT [DF_Appointments_DocumentId] DEFAULT ((0)),
[AppointmentStatusId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Appointments] ADD CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED  ([AppointmentId]) ON [PRIMARY]
GO
