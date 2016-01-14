CREATE TABLE [dbo].[Jobs_Purged]
(
[PurgeID] [int] NOT NULL IDENTITY(1, 1),
[Jobnumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobID] [bigint] NOT NULL,
[DateMarked] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Purged] ADD CONSTRAINT [PK_PurgeID] PRIMARY KEY CLUSTERED  ([PurgeID]) ON [PRIMARY]
GO
