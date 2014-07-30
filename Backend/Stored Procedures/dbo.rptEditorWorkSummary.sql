SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rptEditorWorkSummary] (
   @EditorID varchar(50)
)
AS
	SELECT ReturnedOn, SUM(NumPages) AS NumPages, SUM(NumLines) AS NumLines, 
         SUM(NumChars) AS NumChars, SUM(NumVBC) AS NumVBC, SUM(NumCharsPC) AS NumCharsPC
FROM     dbo.ftEditorJobEditingData(@EditorID)
WHERE ReturnedOn >= DATEADD(day, -60, GETDATE()) 
GROUP BY ReturnedOn
ORDER BY ReturnedOn DESC
RETURN
GO
