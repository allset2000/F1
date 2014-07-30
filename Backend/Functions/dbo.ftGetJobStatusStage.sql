SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftGetJobStatusStage] (
	@JobNumber varchar(20)
)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @StatusStage varchar(50)

	SELECT @StatusStage = StatusStage 
	FROM vwJobsStatusA
	WHERE (JobNumber = @JobNumber)

	RETURN @StatusStage
END
GO
