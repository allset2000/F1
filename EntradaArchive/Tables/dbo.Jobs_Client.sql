CREATE TABLE [dbo].[Jobs_Client]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MD5] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchiveID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Client] ADD CONSTRAINT [PK_Jobs_Client] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Client] ADD CONSTRAINT [FK_Jobs_Client_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
