CREATE TABLE [dbo].[QueueWorkspaces]
(
[QueueWorkspaceId] [int] NOT NULL,
[QueueWorkspaceName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueWorkspacePriorityType] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QueueWorkspaceStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueueWorkspaces] ADD CONSTRAINT [PK_QueueWorkspaces] PRIMARY KEY CLUSTERED  ([QueueWorkspaceId]) ON [PRIMARY]
GO
