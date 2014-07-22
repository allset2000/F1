CREATE TABLE [dbo].[JobsRowTracking]
(
[JobsRowTrackingID] [bigint] NOT NULL IDENTITY(1, 1),
[JobID] [bigint] NOT NULL,
[ChangeMessage] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangeDate] [datetime] NOT NULL CONSTRAINT [DF_JobsRow_Tracking_StatusDate] DEFAULT (getdate()),
[ChangedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsRowTracking] ADD CONSTRAINT [PK_JobsRow_Status] PRIMARY KEY CLUSTERED  ([JobsRowTrackingID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsRowTracking] ADD CONSTRAINT [FK_JobsRowTracking_Jobs] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Jobs] ([JobID]) ON DELETE CASCADE
GO
