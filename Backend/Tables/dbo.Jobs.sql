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
[JobStatus] [smallint] NOT NULL CONSTRAINT [DF_Jobs_JobStatus] DEFAULT ((0)),
[JobStatusDate] [datetime] NOT NULL CONSTRAINT [DF_Jobs_JobStatusDate] DEFAULT ('2078-12-31'),
[JobPath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Jobs_JobPath] DEFAULT (''),
[GenericPatientFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_GenericPatientFlag] DEFAULT ((0)),
[PoorAudioFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_PoorAudioFlag] DEFAULT ((0)),
[TranscriptionModeFlag] [bit] NOT NULL CONSTRAINT [DF_Jobs_TranscriptionModeFlag] DEFAULT ((0)),
[JobEditingSummaryId] [int] NOT NULL CONSTRAINT [DF__Jobs__JobEditing__78159CA3] DEFAULT ((-1)),
[JobId] [int] NOT NULL IDENTITY(2, 1),
[DueDate] [datetime] NULL,
[TemplateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsGenericJob] [bit] NULL,
[IsNewSchema] [bit] NULL,
[ProcessFailureCount] [smallint] NULL,
[IsLockedForProcessing] [bit] NOT NULL CONSTRAINT [DF__Jobs__IsProcesse__274FAE79] DEFAULT ((0)),
[FinaldocSentToBBN] [bit] NOT NULL CONSTRAINT [DF__Jobs__FinaldocSe__186270A4] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ClinicID_INC] ON [dbo].[Jobs] ([ClinicID]) INCLUDE ([AppointmentDate], [AppointmentTime], [CC], [CompletedOn], [DictationDate], [DictationTime], [DictatorID], [DocumentStatus], [Duration], [EditorID], [GenericPatientFlag], [JobEditingSummaryId], [JobId], [JobNumber], [JobType], [Location], [ReceivedOn], [Stat]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsDictatorID] ON [dbo].[Jobs] ([DictatorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_DictatorID_AppointmentDate_includes] ON [dbo].[Jobs] ([DictatorID], [AppointmentDate]) INCLUDE ([ClinicID], [EditorID], [JobEditingSummaryId], [JobNumber], [JobType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsJobEditingSummaryId] ON [dbo].[Jobs] ([JobEditingSummaryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_Jobs_JobId] ON [dbo].[Jobs] ([JobId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ReceivedOn_INC_JobNumber_DictatorID_ClinicID_Location...] ON [dbo].[Jobs] ([ReceivedOn]) INCLUDE ([AppointmentDate], [AppointmentTime], [CC], [ClinicID], [CompletedOn], [DictationDate], [DictationTime], [DictatorID], [DocumentStatus], [Duration], [EditorID], [GenericPatientFlag], [JobEditingSummaryId], [JobId], [JobNumber], [JobType], [Location], [Stat]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_ReturnedOn] ON [dbo].[Jobs] ([ReturnedOn]) INCLUDE ([EditorID], [JobNumber]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_DocumentStatus] FOREIGN KEY ([DocumentStatus]) REFERENCES [dbo].[DocumentStatus] ([DocStatus])
GO
