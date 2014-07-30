CREATE TABLE [dbo].[QueuesOrphanJobs]
(
[OrphanItemId] [int] NOT NULL IDENTITY(1, 1),
[ClinicId] [int] NOT NULL,
[DictatorId] [int] NOT NULL,
[JobType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Stat] [bit] NOT NULL,
[JobsCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueuesOrphanJobs] ADD CONSTRAINT [PK_QueueOrphanJobs] PRIMARY KEY CLUSTERED  ([OrphanItemId]) ON [PRIMARY]
GO
