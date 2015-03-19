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
	 @IncludeErrors bit
) AS 
BEGIN
	IF (@IncludeErrors = 1)
	BEGIN	 
		SELECT TOP 100 J.* FROM Jobs J
			inner join Dictations D on D.JobId = J.JobId
			inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250
		WHERE J.Status = @StatusCode and J.JobId NOT IN (SELECT JobId FROM Errors)
		ORDER BY J.STAT DESC, DT.ChangeDate
	END
	ELSE
	BEGIN
		SELECT TOP 100 J.* FROM Jobs J
			inner join Dictations D on D.JobId = J.JobId
			inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250
		WHERE J.Status = @StatusCode
		ORDER BY J.STAT DESC, DT.ChangeDate
	END
END
GO
