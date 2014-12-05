CREATE TABLE [dbo].[PurgeLog]
(
[PurgeID] [int] NOT NULL IDENTITY(1, 1),
[PolicyID] [int] NOT NULL,
[PurgeAge] [int] NOT NULL,
[PurgeExecutionStartDate] [datetime] NULL,
[PurgeExecutionEndDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurgeLog] ADD CONSTRAINT [PK_PurgeLog] PRIMARY KEY CLUSTERED  ([PurgeID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurgeLog] ADD CONSTRAINT [FK_PurgeLog_ArchivePolicy] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[ArchivePolicy] ([PolicyID])
GO
