CREATE TABLE [dbo].[Jobs_ArchiveDetails]
(
[DocumentArchivedOn] [datetime] NULL,
[DocumentPurgedOn] [datetime] NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrackingArchivedOn] [datetime] NULL,
[TrackingPurgedOn] [datetime] NULL,
[FileArchivedOn] [datetime] NULL,
[FilePurgedOn] [datetime] NULL,
[JobDataArchivedOn] [datetime] NULL,
[JobDataPurgedOn] [datetime] NULL,
[JobEditingTasksArchivedOn] [datetime] NULL,
[JobEditingTasksPurgedOn] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_ArchiveDetails] ADD CONSTRAINT [PK_Jobs_ArchiveDetails] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
