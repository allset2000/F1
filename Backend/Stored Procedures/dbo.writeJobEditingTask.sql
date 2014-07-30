
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeJobEditingTask] (
	@JobEditingTaskId  [int],
	@JobId  [int],
	@AssignedToID  [varchar]  (50),
	@EditionNote  [varchar]  (255),
	@QACategoryId  [int],
	@CurrentStateId  [int],
	@NextStateId  [int],
	@WorkflowRuleId  [int],
	@AssignmentMode  [char]  (1),
	@AssignedById  [int],
	@ReleasedById  [int],
	@AssignedOn  [datetime],
	@ReceivedOn  [datetime],
	@ReturnedOn  [datetime],
	@PreviousTaskId  [int],
	@NextTaskId  [int],
	@TaskStatus  [char]  (1) 
)
AS

IF NOT EXISTS(SELECT * FROM [dbo].[JobEditingTasks] WHERE ([JobEditingTaskId] = @JobEditingTaskId))
	BEGIN
	INSERT INTO [dbo].[JobEditingTasks] (
		[JobEditingTaskId], [JobId], [AssignedToID],[EditionNote],[QACategoryId],
		[CurrentStateId],[NextStateId],[WorkflowRuleId],[AssignmentMode],[AssignedById],
		[ReleasedById],[AssignedOn],[ReceivedOn],[ReturnedOn],[PreviousTaskId],[NextTaskId],[TaskStatus] 
	) VALUES (
		@JobEditingTaskId,@JobId,@AssignedToID,@EditionNote,@QACategoryId,
		@CurrentStateId,@NextStateId,@WorkflowRuleId,@AssignmentMode,@AssignedById,
		@ReleasedById,@AssignedOn,@ReceivedOn,@ReturnedOn,@PreviousTaskId,@NextTaskId,@TaskStatus 
	) 
	END
ELSE 
   BEGIN
		UPDATE [dbo].[JobEditingTasks]
		 SET
		 [AssignedToID] = @AssignedToID ,
		 [EditionNote] = @EditionNote ,
		 [QACategoryId] = @QACategoryId ,
		 [CurrentStateId] = @CurrentStateId ,
		 [NextStateId] = @NextStateId ,
		 [WorkflowRuleId] = @WorkflowRuleId ,
		 [AssignmentMode] = @AssignmentMode ,
		 [AssignedById] = @AssignedById ,
		 [ReleasedById] = @ReleasedById ,
		 [AssignedOn] = @AssignedOn ,
		 [ReceivedOn] = @ReceivedOn ,
		 [ReturnedOn] = @ReturnedOn ,
		 [PreviousTaskId] = @PreviousTaskId ,
		 [NextTaskId] = @NextTaskId ,
		 [TaskStatus] = @TaskStatus  
		WHERE 
			([JobEditingTaskId] = @JobEditingTaskId) and (JobId = @JobId)
	
		IF (@@ROWCOUNT <> 1)
			RAISERROR('UNEXPECTED DATA UPDATING JobEditingTasks table for Job', 10, 1)
	
END
GO
