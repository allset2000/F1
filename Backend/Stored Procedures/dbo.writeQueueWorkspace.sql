SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueueWorkspace] (
	@QueueWorkspaceId  [int],
	@QueueWorkspaceName  [varchar]  (100),
	@QueueWorkspacePriorityType  [varchar]  (8),
	@QueueWorkspaceStatus  [char]  (1) 
) AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
			IF NOT EXISTS(SELECT 1 FROM [dbo].[QueueWorkspaces] WHERE ([QueueWorkspaceId] = @QueueWorkspaceId))
				 BEGIN
					INSERT INTO [dbo].[QueueWorkspaces] (
					   [QueueWorkspaceId], [QueueWorkspaceName], [QueueWorkspacePriorityType], [QueueWorkspaceStatus] 
					) VALUES (
					   @QueueWorkspaceId, @QueueWorkspaceName, @QueueWorkspacePriorityType, @QueueWorkspaceStatus
					)
				 END
			ELSE 
				 BEGIN
					UPDATE [dbo].[QueueWorkspaces] 
					 SET
						 [QueueWorkspaceName] = @QueueWorkspaceName ,
						 [QueueWorkspacePriorityType] = @QueueWorkspacePriorityType ,
						 [QueueWorkspaceStatus] = @QueueWorkspaceStatus  
					WHERE ([QueueWorkspaceId] = @QueueWorkspaceId)
						
					IF (@QueueWorkspaceStatus = 'X') 
					BEGIN
						UPDATE QueueWorkspaceEditors
						SET QueueWorkspaceEditorStatus = 'X'
						WHERE (QueueWorkspaceId = @QueueWorkspaceId)
						
						UPDATE QueueWorkspaceQueues
						SET QueueWorkspaceQueueStatus = 'X'
						WHERE (QueueWorkspaceId = @QueueWorkspaceId)
					END
				END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
			ROLLBACK TRANSACTION
							DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
							SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		   END
	END CATCH
	RETURN
END	
GO
