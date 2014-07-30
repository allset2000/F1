SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobTddSplitRules] (
   @JobNumber varchar(20)
) AS
	SELECT dbo.JobsTddSplitRules.*
	FROM   dbo.JobsTddSplitRules INNER JOIN dbo.Jobs
	ON JobsTddSplitRules.ClinicID = Jobs.ClinicID
	WHERE ([Enabled] = 1) AND (dbo.Jobs.JobNumber = @JobNumber)
	--AND (ISNULL(dbo.JobsTddSplitRules.DictatorID, Jobs.DictatorID) = dbo.Jobs.DictatorID)
RETURN
GO
