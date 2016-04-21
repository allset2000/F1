CREATE TABLE [dbo].[Dictations]
(
[DictationID] [bigint] NOT NULL IDENTITY(1, 1),
[JobID] [bigint] NOT NULL,
[DictationTypeID] [int] NOT NULL,
[DictatorID] [int] NULL,
[QueueID] [int] NULL,
[Status] [smallint] NOT NULL,
[Duration] [smallint] NOT NULL,
[MachineName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientVersion] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDateInUTC] [datetime] NULL CONSTRAINT [DF_Dictations_UpdatedDateInUTC] DEFAULT (getutcdate())
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Dictations_DictatorID] ON [dbo].[Dictations] ([DictatorID]) INCLUDE ([JobID]) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Dictations] ADD CONSTRAINT [PK_Dictations] PRIMARY KEY CLUSTERED  ([DictationID]) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Dictations_JobID] ON [dbo].[Dictations] ([JobID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_QueueID_INC_DictationID_JobID] ON [dbo].[Dictations] ([QueueID]) INCLUDE ([DictationID], [JobID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Dictations_QueueID_Status_INC] ON [dbo].[Dictations] ([QueueID], [Status]) INCLUDE ([JobID], [DictatorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Status_INC_JobID_DictatorID_QueueID] ON [dbo].[Dictations] ([Status]) INCLUDE ([JobID], [DictatorID], [QueueID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictations] ADD CONSTRAINT [FK_Dictations_DictationTypes] FOREIGN KEY ([DictationTypeID]) REFERENCES [dbo].[DictationTypes] ([DictationTypeID])
GO
ALTER TABLE [dbo].[Dictations] ADD CONSTRAINT [FK_Dictations_Jobs] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Jobs] ([JobID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Dictations] ADD CONSTRAINT [FK_Dictations_Queues] FOREIGN KEY ([QueueID]) REFERENCES [dbo].[Queues] ([QueueID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dictation Job Type', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'DictationTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dictator', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'DictatorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Duration in Seconds', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'Duration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dictation FileName', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Dictated', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'MachineName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of Dictation', 'SCHEMA', N'dbo', 'TABLE', N'Dictations', 'COLUMN', N'Status'
GO
