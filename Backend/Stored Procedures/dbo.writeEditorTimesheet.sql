SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeEditorTimesheet] (
	@TimesheetItemId  [int],
	@EditorID  [varchar]  (50),
	@SignInTime  [datetime],
	@SignOffTime  [datetime]
) AS
	IF NOT EXISTS(SELECT * FROM [dbo].[EditorTimesheet] WHERE ([TimesheetItemId] = @TimesheetItemId))
   BEGIN
			INSERT INTO [dbo].[EditorTimesheet] (
				[TimesheetItemId], [EditorID], [SignInTime], [SignOffTime] 
			) VALUES (
				@TimesheetItemId, @EditorID, @SignInTime, NULL
			)
		END
	ELSE 
   BEGIN
			UPDATE [dbo].[EditorTimesheet] 
			 SET
			 [SignOffTime] = @SignOffTime  
			WHERE 
			([TimesheetItemId] = @TimesheetItemId)  AND ([EditorID] = @EditorID)
		END	
RETURN
GO
