CREATE TABLE [dbo].[Queue_Restrictions]
(
[QueueID] [smallint] NOT NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicID] [smallint] NOT NULL CONSTRAINT [DF_Queue_Restrictions_ClinicID] DEFAULT ((0)),
[Location] [smallint] NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Queue_Restrictions_DictatorID] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Restrictions] ADD CONSTRAINT [FK_Queue_Restrictions_Queue_Editors] FOREIGN KEY ([QueueID], [EditorID]) REFERENCES [dbo].[Queue_Editors] ([QueueID], [EditorID])
GO
