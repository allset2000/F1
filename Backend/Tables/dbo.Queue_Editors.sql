CREATE TABLE [dbo].[Queue_Editors]
(
[QueueID] [smallint] NOT NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Priority] [smallint] NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[Queue_Editors] ADD
CONSTRAINT [FK_Queue_Editors_Queue_Names] FOREIGN KEY ([QueueID]) REFERENCES [dbo].[Queue_Names] ([QueueID])
GO
ALTER TABLE [dbo].[Queue_Editors] ADD CONSTRAINT [PK_QueueEditors] PRIMARY KEY CLUSTERED  ([QueueID], [EditorID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Editors] ADD CONSTRAINT [FK_Queue_Editors_Editors] FOREIGN KEY ([EditorID]) REFERENCES [dbo].[Editors] ([EditorID])
GO
