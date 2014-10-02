CREATE TABLE [dbo].[PurgeData]
(
[PurgeDataID] [int] NOT NULL IDENTITY(1, 1),
[ArchiveID] [int] NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PurgeData] [xml] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurgeData] ADD CONSTRAINT [PK_PurgeData] PRIMARY KEY CLUSTERED  ([PurgeDataID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PurgeData] ADD CONSTRAINT [FK_PurgeData_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
