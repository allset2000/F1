CREATE TABLE [dbo].[QueueWorkspaceEditors]
(
[QueueWorkspaceEditorId] [int] NOT NULL IDENTITY(1, 1),
[QueueWorkspaceId] [int] NOT NULL,
[EditorId] [int] NOT NULL,
[QueueWorkspaceEditorStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QueueWorkspaceEditors] ADD CONSTRAINT [PK_QueueWorkspaceEditors] PRIMARY KEY CLUSTERED  ([QueueWorkspaceEditorId]) ON [PRIMARY]
GO
