SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 3/19/2015
-- Description: SP called from Audio Processor to pull jobs to process
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsByStatusCode] (
	 @StatusCode int,
	 @IncludeErrors bit,
	 @ProcessFailureCount INT -- added new parametert to exclude the jobs which were process failured jobs,I was aboou to check-in, looks like Sam checked in with latest changes
) AS 
BEGIN
	IF (@IncludeErrors = 1)
	BEGIN	 
		SELECT TOP 100 J.* FROM Jobs J
			inner join Dictations D on D.JobId = J.JobId
			inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250
		WHERE ((J.Status = @StatusCode) AND (J.ProcessFailureCount is null or J.ProcessFailureCount <= @ProcessFailureCount) and (J.JobId NOT IN (SELECT JobId FROM Errors)))
		ORDER BY J.STAT DESC, DT.ChangeDate
	END
	ELSE
	BEGIN
		SELECT TOP 100 J.* FROM Jobs J
			inner join Dictations D on D.JobId = J.JobId
			inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250
		WHERE (J.Status = @StatusCode) AND (J.ProcessFailureCount is null or J.ProcessFailureCount <= @ProcessFailureCount)
		ORDER BY J.STAT DESC, DT.ChangeDate
	END
END
GO
