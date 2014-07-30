SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ftMacroBillingTotals] (	
	@JobEditingTaskId  [int]
)
RETURNS TABLE 
AS
RETURN (
	SELECT COUNT(*) - 1 AS NumTotalMacros,
		SUM(CASE WHEN [WasEdited] = 1 THEN 0 ELSE 1 END) - 1 AS  NumMacrosUnEdited,
		SUM(CASE WHEN [WasEdited] = 1 THEN 1 ELSE 0 END) AS  NumMacrosEdited,
		SUM([NumCharsUnEdited]) AS  NumCharsUnEditedMacros,
		SUM([NumCharsEdited]) AS NumCharsEditedMacros,
		SUM([NumCharsChanged]) AS NumCharsChangedMacros	
	FROM JobEditingTaskMacros
	WHERE (JobEditingTaskId = @JobEditingTaskId) OR (JobEditingTaskId = -1)
)
GO
