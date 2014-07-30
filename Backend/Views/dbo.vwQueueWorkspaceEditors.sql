SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwQueueWorkspaceEditors]
AS
SELECT     dbo.QueueWorkspaceEditors.*
FROM         dbo.QueueWorkspaceEditors
WHERE     (QueueWorkspaceEditorStatus = 'A')
GO
