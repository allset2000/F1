CREATE TABLE [dbo].[Jobs_Client]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MD5] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Client] ADD CONSTRAINT [PK_Jobs_Client] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Client_Dictator] ON [dbo].[Jobs_Client] ([DictatorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jobs_Client_FileName] ON [dbo].[Jobs_Client] ([FileName]) ON [PRIMARY]
GO
