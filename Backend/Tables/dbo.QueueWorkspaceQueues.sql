CREATE TABLE [dbo].[QueueWorkspaceQueues]
(
[QueueWorkspaceQueueId] [int] NOT NULL IDENTITY(1, 1),
[QueueWorkspaceId] [int] NOT NULL,
[QueueId] [int] NOT NULL,
[QueuePriority] [int] NOT NULL,
[QueueWorkspaceQueueStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueueWorkspaceQueues] ADD CONSTRAINT [PK_QueueWorkspaceItems] PRIMARY KEY CLUSTERED  ([QueueWorkspaceQueueId]) ON [PRIMARY]
GO
