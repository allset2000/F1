CREATE TABLE [dbo].[Jobs]
(
[JobID] [bigint] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicID] [smallint] NOT NULL,
[EncounterID] [bigint] NOT NULL,
[JobTypeID] [int] NOT NULL,
[OwnerDictatorID] [int] NULL,
[Status] [smallint] NOT NULL,
[Stat] [bit] NOT NULL,
[Priority] [smallint] NOT NULL CONSTRAINT [DF_Jobs_Priority] DEFAULT ((0)),
[RuleID] [smallint] NULL,
[AdditionalData] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessFailureCount] [smallint] NULL,
[UpdatedDateInUTC] [datetime] NULL CONSTRAINT [DF_JOBS_UpdatedDateInUTC] DEFAULT (getutcdate()),
[HasDictation] [bit] NULL CONSTRAINT [DF_Jobs_HasDictation] DEFAULT ((0)),
[HasImages] [bit] NULL CONSTRAINT [DF_Jobs_HasImages] DEFAULT ((0)),
[HasTagMetaData] [bit] NULL CONSTRAINT [DF_Jobs_HasTagMetaData] DEFAULT ((0)),
[HasChatHistory] [bit] NULL CONSTRAINT [DF_Jobs_HasChatHistory] DEFAULT ((0)),
[OwnerUserID] [int] NULL,
[TagMetaData] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChatHistory_ThreadID] [int] NULL,
[BackendStatus] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Jobs_ClinicID_JobAddData] ON [dbo].[Jobs] ([ClinicID]) INCLUDE ([AdditionalData], [JobNumber], [OwnerDictatorID], [Priority], [RuleID], [Stat]) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_Jobs_JobNumber] ON [dbo].[Jobs] ([JobNumber], [ClinicID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_Status] ON [dbo].[Jobs] ([Status]) INCLUDE ([OwnerDictatorID], [Stat], [UpdatedDateInUTC], [BackendStatus], [JobID], [JobNumber], [EncounterID], [JobTypeID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Jobs_OwnerDictatorID] ON [dbo].[Jobs] ([OwnerDictatorID], [Status]) INCLUDE ([JobID], [EncounterID]) ON [PRIMARY]



CREATE NONCLUSTERED INDEX [IX_Jobs_ProcessFailureCount] ON [dbo].[Jobs] ([ProcessFailureCount]) INCLUDE ([JobID], [JobNumber], [Status]) ON [PRIMARY]

ALTER TABLE [dbo].[Jobs] ADD
CONSTRAINT [CK_jobs_Status_colHasLength] CHECK (([Status]>(0)))
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED  ([JobID]) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [FK_EncounterID_Status] ON [dbo].[Jobs] ([EncounterID], [Status]) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Jobs_JobTypeID] ON [dbo].[Jobs] ([JobTypeID]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_Appointments] FOREIGN KEY ([EncounterID]) REFERENCES [dbo].[Encounters] ([EncounterID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_JobTypes] FOREIGN KEY ([JobTypeID]) REFERENCES [dbo].[JobTypes] ([JobTypeID])
GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [FK_Jobs_Dictators] FOREIGN KEY ([OwnerDictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Main Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Jobs', 'COLUMN', N'JobTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dictator Owner', 'SCHEMA', N'dbo', 'TABLE', N'Jobs', 'COLUMN', N'OwnerDictatorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Priority of Job', 'SCHEMA', N'dbo', 'TABLE', N'Jobs', 'COLUMN', N'Priority'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rule Applied to Create Job', 'SCHEMA', N'dbo', 'TABLE', N'Jobs', 'COLUMN', N'RuleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of the Whole Job', 'SCHEMA', N'dbo', 'TABLE', N'Jobs', 'COLUMN', N'Status'
GO
