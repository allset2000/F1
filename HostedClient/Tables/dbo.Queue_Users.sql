CREATE TABLE [dbo].[Queue_Users]
(
[QueueID] [int] NOT NULL,
[DictatorID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Users] ADD CONSTRAINT [PK_Queue_Users] PRIMARY KEY CLUSTERED  ([QueueID], [DictatorID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queue_Users] ADD CONSTRAINT [FK_Queue_Users_Dictators] FOREIGN KEY ([DictatorID]) REFERENCES [dbo].[Dictators] ([DictatorID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Queue_Users] ADD CONSTRAINT [FK_Queue_Users_Queues] FOREIGN KEY ([QueueID]) REFERENCES [dbo].[Queues] ([QueueID]) ON DELETE CASCADE
GO
