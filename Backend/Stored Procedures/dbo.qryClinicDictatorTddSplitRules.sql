SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryClinicDictatorTddSplitRules] (
   @ClinicID smallint,
   @DictatorID varchar(50)
) AS

	SELECT *
	FROM   dbo.JobsTddSplitRules
	WHERE ([Enabled] = 1) AND (ClinicID = @ClinicID) AND (DictatorID = @DictatorID)
	
	UNION
	
	SELECT *
	FROM   dbo.JobsTddSplitRules
	WHERE ([Enabled] = 1) AND (ClinicID = @ClinicID) AND (ISNULL(DictatorID,'') = '') 
	AND JobType NOT IN (SELECT DISTINCT JobType
						FROM   dbo.JobsTddSplitRules
						WHERE ([Enabled] = 1) AND (ClinicID = @ClinicID) AND (DictatorID = @DictatorID))
RETURN
GO
