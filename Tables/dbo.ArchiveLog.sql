CREATE TABLE [dbo].[ArchiveLog]
(
[ArchiveID] [int] NOT NULL IDENTITY(1, 1),
[PolicyID] [int] NOT NULL,
[ArchiveAge] [int] NOT NULL,
[ArchiveExecutionStartDate] [datetime] NULL,
[ArchiveExecutionEndDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArchiveLog] ADD CONSTRAINT [PK_ArchiveLog] PRIMARY KEY CLUSTERED  ([ArchiveID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArchiveLog] ADD CONSTRAINT [FK_ArchiveLog_ArchivePolicy] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[ArchivePolicy] ([PolicyID])
GO
