SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftCalculateJobDueDate] (
   @JobNumber varchar(20)
)
RETURNS datetime
AS
BEGIN

	DECLARE @ReceivedOn datetime
	DECLARE @ClinicID smallint
	DECLARE @DictatorID varchar(50)
	DECLARE @JobType	varchar(200)
	DECLARE @Stat bit
	
	SELECT @ReceivedOn = ReceivedOn, @ClinicID = ClinicID, 
	       @DictatorID = DictatorID, @JobType = JobType, @Stat = Stat
	FROM Jobs
	WHERE (JobNumber = @JobNumber)			

	DECLARE @DueMinutes int
	SET @DueMinutes = 0

	IF (@DueMinutes = 0)
	BEGIN
		SELECT @DueMinutes = [DueMinutes]
		FROM   dbo.JobDueDateRules
		WHERE ([RuleStatus] = 'A') AND ([RuleApplicationTime] <= @ReceivedOn) AND 
			   (ClinicID = @ClinicID) AND (DictatorID = @DictatorID) AND (JobType = @JobType) AND 
			   ((@Stat = 1 AND ApplyToStat IN ('T', 'B')) OR (@Stat = 0 AND ApplyToStat IN ('F', 'B')))
	END
	
	IF (@DueMinutes = 0)
	BEGIN
		SELECT  @DueMinutes = [DueMinutes]
		FROM   dbo.JobDueDateRules
		WHERE ([RuleStatus] = 'A') AND ([RuleApplicationTime] <= @ReceivedOn) AND 
			   (ClinicID = @ClinicID) AND (DictatorID = @DictatorID) AND (JobType = '') AND
			   ((@Stat = 1 AND ApplyToStat IN ('T', 'B')) OR (@Stat = 0 AND ApplyToStat IN ('F', 'B')))
	END

	IF (@DueMinutes = 0)
	BEGIN
		SELECT  @DueMinutes = [DueMinutes]
		FROM   dbo.JobDueDateRules
		WHERE ([RuleStatus] = 'A') AND ([RuleApplicationTime] <= @ReceivedOn) AND 
			   (ClinicID = @ClinicID) AND (DictatorID = '') AND (JobType = @JobType) AND
			   ((@Stat = 1 AND ApplyToStat IN ('T', 'B')) OR (@Stat = 0 AND ApplyToStat IN ('F', 'B')))
	END
		
	IF (@DueMinutes = 0)
	BEGIN
		SELECT  @DueMinutes = [DueMinutes]
		FROM   dbo.JobDueDateRules
		WHERE ([RuleStatus] = 'A') AND ([RuleApplicationTime] <= @ReceivedOn) AND 
			   (ClinicID = @ClinicID) AND (DictatorID = '') AND (JobType = '') AND
			   ((@Stat = 1 AND ApplyToStat IN ('T', 'B')) OR (@Stat = 0 AND ApplyToStat IN ('F', 'B')))
	END

	IF (@DueMinutes <> 0)
		RETURN DATEADD(mi, @DueMinutes, @ReceivedOn)

	RETURN NULL
END
GO
