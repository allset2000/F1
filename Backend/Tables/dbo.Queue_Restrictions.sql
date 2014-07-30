CREATE TABLE [dbo].[Queue_Restrictions]
(
[QueueID] [smallint] NOT NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicID] [smallint] NULL,
[Location] [smallint] NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Restrictions] ADD CONSTRAINT [FK_Queue_Restrictions_Queue_Editors] FOREIGN KEY ([QueueID], [EditorID]) REFERENCES [dbo].[Queue_Editors] ([QueueID], [EditorID])
GO
