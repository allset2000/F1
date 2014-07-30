SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueue] (
	@QueueId  [int],
	@QueueName  [varchar]  (64),
	@QueueStatus  [char]  (1)  
) AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
			IF NOT EXISTS(SELECT * FROM [dbo].[Queues] WHERE ([QueueId] = @QueueId))
				 BEGIN
					INSERT INTO [dbo].[Queues] (
						[QueueId], [QueueName], [QueueStatus] 
					) VALUES (
						@QueueId,@QueueName, @QueueStatus 
					)
				 END
			ELSE 
				 BEGIN
					UPDATE [dbo].[Queues] 
					 SET
						 [QueueName] = @QueueName,
						 [QueueStatus] = @QueueStatus  
					WHERE 
						([QueueId] = @QueueId)
						
					IF (@QueueStatus = 'X')
					BEGIN		
						UPDATE QueueWorkspaceQueues
						SET QueueWorkspaceQueueStatus = 'X'
						WHERE (QueueId = @QueueId)
						
						UPDATE QueueMembers
						SET QueueMemberStatus = 'X'
						WHERE (QueueId = @QueueId)
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
