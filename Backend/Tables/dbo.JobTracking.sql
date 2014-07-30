CREATE TABLE [dbo].[JobTracking]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NOT NULL,
[StatusDate] [datetime] NULL,
[Path] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobTracking] ON [dbo].[JobTracking] ([JobNumber]) ON [PRIMARY]
GO
