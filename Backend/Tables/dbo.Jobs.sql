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
[TemplateName] [varchar] (100) NULL,
[IsGenericJob] [bit] NULL,
[IsNewSchema] [bit] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[Jobs] ADD 
CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ClinicID_INC] ON [dbo].[Jobs] ([ClinicID]) INCLUDE ([AppointmentDate], [AppointmentTime], [CC], [CompletedOn], [DictationDate], [DictationTime], [DictatorID], [DocumentStatus], [Duration], [EditorID], [GenericPatientFlag], [JobEditingSummaryId], [JobId], [JobNumber], [JobType], [Location], [ReceivedOn], [Stat]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ReceivedOn_INC_JobNumber_DictatorID_ClinicID_Location...] ON [dbo].[Jobs] ([ReceivedOn]) INCLUDE ([AppointmentDate], [AppointmentTime], [CC], [ClinicID], [CompletedOn], [DictationDate], [DictationTime], [DictatorID], [DocumentStatus], [Duration], [EditorID], [GenericPatientFlag], [JobEditingSummaryId], [JobId], [JobNumber], [JobType], [Location], [Stat]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_ReturnedOn] ON [dbo].[Jobs] ([ReturnedOn]) INCLUDE ([EditorID], [JobNumber]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsDictatorID] ON [dbo].[Jobs] ([DictatorID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsClinicIDLocationID] ON [dbo].[Jobs] ([ClinicID], [Location]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsEditorID] ON [dbo].[Jobs] ([EditorID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_AppointmentId] ON [dbo].[Jobs] ([AppointmentId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_DocumentId] ON [dbo].[Jobs] ([DocumentId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_JobStatus] ON [dbo].[Jobs] ([JobStatus]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsJobEditingSummaryId] ON [dbo].[Jobs] ([JobEditingSummaryId]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobsJobId] ON [dbo].[Jobs] ([JobId]) ON [PRIMARY]

ALTER TABLE [dbo].[Jobs] ADD
CONSTRAINT [FK_Jobs_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID])
ALTER TABLE [dbo].[Jobs] ADD
CONSTRAINT [FK_Jobs_DocumentStatus] FOREIGN KEY ([DocumentStatus]) REFERENCES [dbo].[DocumentStatus] ([DocStatus])
GO
