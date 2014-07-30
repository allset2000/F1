SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doSwapQueuesPrioritiesInWorkspace] (
	@QueueWorkspaceId int,
	@QueueOneId int,
	@QueueTwoId int
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE @tempPriorityOne int
			DECLARE @tempPriorityTwo int
			
			SELECT @tempPriorityOne = QueuePriority 
			FROM [dbo].QueueWorkspaceQueues
			WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueOneId);

			SELECT @tempPriorityTwo = QueuePriority 
			FROM [dbo].QueueWorkspaceQueues
			WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueTwoId);
						
			UPDATE [dbo].QueueWorkspaceQueues
			SET QueuePriority = @tempPriorityTwo
			WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueOneId);

			UPDATE [dbo].QueueWorkspaceQueues
			SET QueuePriority = @tempPriorityOne
			WHERE (QueueWorkspaceId = @QueueWorkspaceId) AND (QueueId = @QueueTwoId);			
			
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
