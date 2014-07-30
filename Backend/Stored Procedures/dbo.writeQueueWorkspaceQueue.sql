SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueueWorkspaceQueue] (
	@QueueWorkspaceId  [int],
	@QueueId  [int],
	@QueuePriority  [int],
	@QueueWorkspaceQueueStatus  [char]  (1) 
) AS 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS(SELECT 1 FROM [dbo].[QueueWorkspaceQueues] 
					  WHERE (QueueWorkspaceId = @QueueWorkspaceId AND QueueId = @QueueId))
			 BEGIN
				INSERT INTO [dbo].[QueueWorkspaceQueues] (
				   [QueueWorkspaceId], [QueueId], [QueuePriority], [QueueWorkspaceQueueStatus] 
				) VALUES (
				   @QueueWorkspaceId, @QueueId, @QueuePriority, @QueueWorkspaceQueueStatus 
				)
			 END
		ELSE 
			 BEGIN
				-- DELETE QUEUE IN WORKSPACE
				IF (@QueueWorkspaceQueueStatus = 'X')
				   BEGIN
				    
					DECLARE @tempPriority int

					SELECT @tempPriority = QueuePriority 
					FROM [dbo].QueueWorkspaceQueues
					WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueId);

					-- Remove the queue from the queue workspace
					 UPDATE [dbo].[QueueWorkspaceQueues] 
					 SET
						 [QueuePriority] = -1,
						 [QueueWorkspaceQueueStatus] = 'X'  
					 WHERE  (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueId)

					 -- Move all queue workspace items (queues) one position backwards
					 UPDATE [dbo].[QueueWorkspaceQueues] 
					 SET
						 [QueuePriority] = QueuePriority - 1
					 WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND ([QueuePriority] > @tempPriority)

				   END
				ELSE  -- OTHER EDITION OPERATION
				   BEGIN
					 UPDATE [dbo].[QueueWorkspaceQueues] 
					 SET
						 [QueuePriority] = @QueuePriority,  					 
						 [QueueWorkspaceQueueStatus] = @QueueWorkspaceQueueStatus  
					 WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueId)		
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
