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
[ProcessFailureCount] [smallint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Jobs] ADD CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED  ([JobID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_ClinicID] ON [dbo].[Jobs] ([ClinicID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UNQ_ClinicID_Jobnumber] ON [dbo].[Jobs] ([ClinicID], [JobNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FK_EncounterID_Status] ON [dbo].[Jobs] ([EncounterID], [Status]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Jobs_JobNumber] ON [dbo].[Jobs] ([JobNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_JobTypeID] ON [dbo].[Jobs] ([JobTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Status] ON [dbo].[Jobs] ([Status]) ON [PRIMARY]
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
