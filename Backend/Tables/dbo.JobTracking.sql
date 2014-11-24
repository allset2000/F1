CREATE TABLE [dbo].[JobTracking]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NOT NULL,
[StatusDate] [datetime] NULL,
[Path] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobTracking] ON [dbo].[JobTracking] ([JobNumber], [Status]) INCLUDE ([StatusDate]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_JobTracking_Status] ON [dbo].[JobTracking] ([Status], [JobNumber]) INCLUDE ([StatusDate]) ON [PRIMARY]

ALTER TABLE [dbo].[JobTracking] ADD 
CONSTRAINT [PK_JobTracking] PRIMARY KEY CLUSTERED  ([StatusID]) ON [PRIMARY]
GO
