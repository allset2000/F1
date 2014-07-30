SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeJobEditingTaskMacro] (
	@JobEditingTaskId  [int],
	@MacroName  [varchar]  (100),
	@WasEdited  [bit],
	@NumCharsUnEdited  [int],
	@NumCharsEdited  [int],
	@NumCharsChanged  [int] 
) AS 

	INSERT INTO [dbo].[JobEditingTaskMacros] (
		[JobEditingTaskId],
		[MacroName],
		[WasEdited],
		[NumCharsUnEdited],
		[NumCharsEdited],
		[NumCharsChanged] 
	) VALUES (
		@JobEditingTaskId,
		@MacroName,
		@WasEdited,
		@NumCharsUnEdited,
		@NumCharsEdited,
		@NumCharsChanged 
	)
GO
