SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeJobEditingSummary] (
	@JobId  [int],
	@LastEditedByID  [varchar]  (50),
	@CurrentlyEditedByID  [varchar]  (50),
	@LastQAEditorID  [varchar]  (50),
	@CurrentStateId  [int],
	@CurrentQAStage  [varchar]  (50),
	@LastQAStage  [varchar]  (50),
	@AssignedToID  [varchar]  (50),
	@QACategoryId  [int],
	@LastQANote  [varchar]  (255),
	@QAEditorsList  [varchar]  (512),
	@FinishedOn  [smalldatetime],
	@EditorEditingTaskId  [int],
	@LastEditingTaskId  [int],
	@LastQAEditingTaskId  [int],
	@BillingEditingTaskId  [int] 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[JobEditingSummary] WHERE ([JobId] = @JobId))
	 BEGIN
		INSERT INTO [dbo].[JobEditingSummary]	(
			[JobId], [LastEditedByID], [CurrentlyEditedByID], [LastQAEditorID], [CurrentStateId],
			[CurrentQAStage], [LastQAStage], [AssignedToID], [QACategoryId], [LastQANote], [QAEditorsList],
			[FinishedOn], [EditorEditingTaskId], [LastEditingTaskId], [LastQAEditingTaskId], [BillingEditingTaskId] 
		) VALUES (
			@JobId, @LastEditedByID, @CurrentlyEditedByID, @LastQAEditorID, @CurrentStateId,
			@CurrentQAStage, @LastQAStage, @AssignedToID, @QACategoryId, @LastQANote, @QAEditorsList,
			@FinishedOn, @EditorEditingTaskId, @LastEditingTaskId, @LastQAEditingTaskId, @BillingEditingTaskId
		)
		UPDATE [dbo].[Jobs]
		SET JobEditingSummaryId = @JobId
		WHERE [JobId] = @JobId
	END
ELSE 
	 BEGIN
		UPDATE [dbo].[JobEditingSummary] 
		 SET
			 [LastEditedByID] = @LastEditedByID ,
			 [CurrentlyEditedByID] = @CurrentlyEditedByID ,
			 [LastQAEditorID] = @LastQAEditorID ,
			 [CurrentStateId] = @CurrentStateId ,
			 [CurrentQAStage] = @CurrentQAStage ,
			 [LastQAStage] = @LastQAStage ,
			 [AssignedToID] = @AssignedToID ,
			 [QACategoryId] = CASE WHEN QACategoryId = -1 THEN @QACategoryId ELSE QACategoryId END ,
			 [LastQANote] = @LastQANote ,
			 [QAEditorsList] = @QAEditorsList ,
			 [FinishedOn] = @FinishedOn ,
			 [EditorEditingTaskId] = CASE WHEN EditorEditingTaskId = -1 THEN @EditorEditingTaskId ELSE EditorEditingTaskId END ,
			 [LastEditingTaskId] = @LastEditingTaskId ,
			 [LastQAEditingTaskId] = @LastQAEditingTaskId ,
			 [BillingEditingTaskId] = CASE WHEN BillingEditingTaskId = -1 THEN @BillingEditingTaskId ELSE BillingEditingTaskId END  
		WHERE 
			([JobId] = @JobId) 
	END
GO
