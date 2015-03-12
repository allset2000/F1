SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 03/11/2015
-- Description: SP Used to split job at QA level: will updated the JobEditingTasks and JobEditingSummary tables with data needed for
-- workflow state for new job based on the workflow state information of parent job
-- =============================================
CREATE PROCEDURE sp_UpdateQAsplitJobEditingTaskData
 @parentJobID varchar(20),
 @newJobID varchar(20)
AS
BEGIN
DECLARE @oldJobId int DECLARE @AssignedToID varchar(20)
DECLARE @EditionNote varchar(255) DECLARE @QACategoryId int DECLARE @CurrentStateId int DECLARE @NextStateId int
DECLARE @WorkflowRuleId int DECLARE @AssignmentMode char(1) DECLARE @AssignedById int DECLARE @ReleasedById int
DECLARE @AssignedOn datetime DECLARE @ReceivedOn datetime DECLARE @ReturnedOn datetime 
DECLARE @PreviousTaskId int DECLARE @NextTaskId int DECLARE @TaskStatus char(1)

DECLARE cursor_EditingTasks CURSOR
STATIC FOR
	SELECT AssignedToID, EditionNote, QACategoryId, CurrentStateId, NextStateId, WorkflowRuleId, AssignmentMode,
		AssignedById, ReleasedById, AssignedOn, ReceivedOn, ReturnedOn, TaskStatus from JobEditingTasks where JobId = @parentJobID
	OPEN cursor_EditingTasks
		IF @@CURSOR_ROWS > 0
			BEGIN
				FETCH NEXT FROM cursor_EditingTasks INTO @AssignedToID, @EditionNote, @QACategoryId, @CurrentStateId, @NextStateId,
							@WorkflowRuleId, @AssignmentMode,@AssignedById, @ReleasedById, @AssignedOn, @ReceivedOn, @ReturnedOn, @TaskStatus
				WHILE @@Fetch_status = 0
					BEGIN
						-- setting prev and next taskid to -1
						set @PreviousTaskId = -1
						set @NextTaskId = -1
						
						declare @newCurrentEditingTaskID int declare @prevEditingTaskID int declare @nextEditingTaskID int
						-- get a new EditingTaskId, for this we are using a temp table and using the existing SP to get a new EditingTaskId
						CREATE TABLE #tmpTable1 ( returnID int)
						INSERT INTO #tmpTable1(returnID) 
						exec getNextObjectId "JobEditingTasks"
						select @newCurrentEditingTaskID = returnID from #tmpTable1
						drop table #tmpTable1

						declare @currentRecords int -- if this is next insert then the prevId will be the prevEditingId( which was insert before this)
						select @currentRecords  = count(1) from JobEditingTasks where JobId = @newJobID
						if(@currentRecords >0)
							begin
								set @PreviousTaskId = @prevEditingTaskID
							end
					
						-- now insert a new record into JobEditingTask table
						exec writeJobEditingTask @newCurrentEditingTaskID, @newJobID, @AssignedToID, @EditionNote, @QACategoryId, @CurrentStateId, @NextStateId, @WorkflowRuleId,
							 @AssignmentMode, @AssignedById, @ReleasedById, @AssignedOn, @ReceivedOn, @ReturnedOn, @PreviousTaskId, @NextTaskId, @TaskStatus


							-- update the prev record based on prev id set the nextId with current Id, -- check if there any records exists an update
							IF EXISTS(SELECT * FROM [dbo].[JobEditingTasks] WHERE (JobId = @newJobID and JobEditingTaskId = @PreviousTaskId))
								BEGIN
									Update JobEditingTasks set NextTaskId = @newCurrentEditingTaskID where JobId = @newJobID and JobEditingTaskId = @PreviousTaskId
								END

							set @prevEditingTaskID = @newCurrentEditingTaskID

						-- get next row
						FETCH NEXT FROM cursor_EditingTasks INTO @AssignedToID, @EditionNote, @QACategoryId, @CurrentStateId, @NextStateId, 
							@WorkflowRuleId, @AssignmentMode, @AssignedById, @ReleasedById, @AssignedOn, @ReceivedOn, @ReturnedOn, @TaskStatus
					END
			END
	CLOSE cursor_EditingTasks
	DEALLOCATE cursor_EditingTasks

	-- insert record into JobEditingSummary table
	declare @editorEditingTaskId int
	select @editorEditingTaskId = JobEditingTaskId from JobEditingTasks where JobId = @newJobID and PreviousTaskId = -1
	declare @lastEditingTaskId int
	set @lastEditingTaskId = @editorEditingTaskId
	select @lastEditingTaskId = JobEditingTaskId from JobEditingTasks where JobId = @newJobID and NextStateId = -1 
	
	IF NOT EXISTS(SELECT * FROM [dbo].[JobEditingSummary] WHERE (JobId = @newJobID))
		BEGIN
			INSERT INTO [dbo].[JobEditingSummary]
				   ([JobId],[EditorEditingTaskId],[LastEditingTaskId],[LastQAEditingTaskId],[LastEditedByID],[CurrentlyEditedByID],[LastQAEditorID],[CurrentStateId],[CurrentQAStage],[LastQAStage],[AssignedToID],[QACategoryId],
				   [LastQANote],[QAEditorsList],[FinishedOn],[BillingEditingTaskId])
				SELECT @newJobID,@editorEditingTaskId,@lastEditingTaskId,@lastEditingTaskId, [LastEditedByID],[CurrentlyEditedByID],[LastQAEditorID],[CurrentStateId],[CurrentQAStage],[LastQAStage],[AssignedToID],[QACategoryId],
				   [LastQANote],[QAEditorsList],[FinishedOn],[BillingEditingTaskId] FROM [dbo].[JobEditingSummary] where JobId = @parentJobID
	
			-- Update Jobs table setting the new JobId for column JobEditingSummaryId for this new job record
			update Jobs set JobEditingSummaryId = @newJobID where JobId = @newJobID
		END
	SET NOCOUNT OFF 
END
GO
