SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueueWorkspaceEditor] (
	@QueueWorkspaceId  [int],
	@EditorId  [int],
	@QueueWorkspaceEditorStatus  [char]  (1) 
) AS 
IF NOT EXISTS(SELECT 1 FROM [dbo].[QueueWorkspaceEditors] WHERE(QueueWorkspaceId = @QueueWorkspaceId AND EditorId = @EditorId))
	 BEGIN
		INSERT INTO [dbo].[QueueWorkspaceEditors] (
			[QueueWorkspaceId], [EditorId], [QueueWorkspaceEditorStatus] 
		) VALUES (
			@QueueWorkspaceId, @EditorId, @QueueWorkspaceEditorStatus 
		)
	 END
ELSE 
	 BEGIN
		UPDATE [dbo].[QueueWorkspaceEditors] 
		 SET
			 [QueueWorkspaceEditorStatus] = @QueueWorkspaceEditorStatus  
		WHERE 
			(QueueWorkspaceId = @QueueWorkspaceId AND EditorId = @EditorId)
	END
GO
