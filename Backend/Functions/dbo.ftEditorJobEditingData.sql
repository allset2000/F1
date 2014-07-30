SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftEditorJobEditingData] (	
   @EditorID varchar(50)
)
RETURNS TABLE 
AS
RETURN (
	SELECT JobNumber, 
	 CASE WHEN EditionStage = 'Editor'
	          THEN CAST(STR(YEAR(ReturnedOn)) + '-' + STR(MONTH(ReturnedOn)) + '-' + STR(DAY(ReturnedOn)) AS DATETIME)
	      WHEN (EditionStage = 'QA')
	          THEN CAST(STR(YEAR(CompletedOn)) + '-' + STR(MONTH(CompletedOn)) + '-' + STR(DAY(CompletedOn)) AS DATETIME)
	      ELSE CAST('1900-01-01' AS DATETIME)
	 END AS ReturnedOn,
	 NumPages, NumLines, NumChars, NumVBC, NumCharsPC
	FROM dbo.vwJobsEditingTasksData
	WHERE  (AssignedToID = @EditorID)
)
GO
