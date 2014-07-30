SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryEditorJobsCountByDictator] (
   @EditorID varchar(50)
)
AS
	SELECT DictatorID, COUNT(JobNumber) AS JobsCount, SUM(CASE [Stat] WHEN 1 THEN 1 ELSE 0 END) AS StatJobsCount
	FROM   dbo.vwMedicalJobs
	WHERE ((AssignedToID = @EditorID) AND ([StatusClass] = 'JobDownloaded'))
	GROUP BY DictatorID
	ORDER BY DictatorID
RETURN
GO
