CREATE TABLE [dbo].[JobsTracking]
(
[JobsTrackingID] [bigint] NOT NULL IDENTITY(1, 1),
[JobID] [bigint] NOT NULL,
[Status] [smallint] NOT NULL,
[ChangeDate] [datetime] NOT NULL CONSTRAINT [DF_Jobs_Tracking_StatusDate] DEFAULT (getdate()),
[ChangedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_JobID_INC_JobsTrackingID] ON [dbo].[JobsTracking] ([JobID]) INCLUDE ([JobsTrackingID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[JobsTracking] ADD CONSTRAINT [PK_Jobs_Status] PRIMARY KEY CLUSTERED  ([JobsTrackingID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsTracking] ADD CONSTRAINT [FK_JobsTracking_Jobs] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Jobs] ([JobID]) ON DELETE CASCADE
GO
