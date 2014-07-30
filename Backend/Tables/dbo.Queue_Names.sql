CREATE TABLE [dbo].[Queue_Names]
(
[QueueID] [smallint] NOT NULL IDENTITY(1, 1),
[QueueName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Names] ADD CONSTRAINT [PK_Queue_Names] PRIMARY KEY CLUSTERED  ([QueueID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'10-Normal / 20 - QA', 'SCHEMA', N'dbo', 'TABLE', N'Queue_Names', 'COLUMN', N'Type'
GO
