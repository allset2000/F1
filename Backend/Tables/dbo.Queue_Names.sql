CREATE TABLE [dbo].[Queue_Names]
(
[QueueID] [smallint] NOT NULL,
[QueueName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [tinyint] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[Queue_Names] ADD 
CONSTRAINT [PK_QueueNames] PRIMARY KEY CLUSTERED  ([QueueID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'10-Normal / 20 - QA', 'SCHEMA', N'dbo', 'TABLE', N'Queue_Names', 'COLUMN', N'Type'
GO
