CREATE TABLE [dbo].[Jobs]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicID] [smallint] NOT NULL,
[Location] [smallint] NOT NULL,
[AppointmentDate] [smalldatetime] NULL,
[AppointmentTime] [smalldatetime] NULL,
[JobType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContextName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vocabulary] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Stat] [bit] NOT NULL,
[CC] [bit] NULL CONSTRAINT [DF_Jobs_CC] DEFAULT ((0)),
[Duration] [smallint] NOT NULL,
[DictationDate] [smalldatetime] NULL,
[DictationTime] [smalldatetime] NULL,
[ReceivedOn] [datetime] NOT NULL,
[ReturnedOn] [datetime] NULL,
[CompletedOn] [datetime] NULL,
[RecServer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BilledOn] [datetime] NULL,
[Amount] [money] NULL,
[ParentJobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentStatus] [smallint] NULL,
[AppointmentId] [int] NOT NULL CONSTRAINT [DF_Jobs_AppointmentId] DEFAULT ((0)),
[DocumentId] [int] NOT NULL CONSTRAINT [DF_Jobs_DocumentId] DEFAULT ((0)),
[JobId] [int] NOT NULL IDENTITY(1, 1),
[JobStatus] [smallint] NOT NULL CONSTRAINT [DF_Jobs_JobStatus] DEFAULT ((0)),
[JobStatusDate] [datetime] NOT NULL CONSTRAINT [DF_Jobs_JobStatusDate] DEFAULT ('2078-12-31'),
[JobPath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Jobs_JobPath] DEFAULT (''),
[GenericPatientFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_GenericPatientFlag] DEFAULT ((0)),
[PoorAudioFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_PoorAudioFlag] DEFAULT ((0)),
[TranscriptionModeFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_TranscriptionModeFlag] DEFAULT ((0)),
[JobEditingSummaryId] [int] NOT NULL CONSTRAINT [DF_Jobs_JobEditingSummary] DEFAULT ((-1)),
[DueDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_AppointmentId] ON [dbo].[Jobs] ([AppointmentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_DocumentId] ON [dbo].[Jobs] ([DocumentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsJobEditingSummaryId] ON [dbo].[Jobs] ([JobEditingSummaryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsJobId] ON [dbo].[Jobs] ([JobId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_JobStatus] ON [dbo].[Jobs] ([JobStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobReceivedOn] ON [dbo].[Jobs] ([ReceivedOn]) ON [PRIMARY]
GO
