CREATE TABLE [dbo].[Queues]
(
[QueueId] [int] NOT NULL,
[QueueName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Queues] ADD CONSTRAINT [PK_Queues] PRIMARY KEY CLUSTERED  ([QueueId]) ON [PRIMARY]
GO
