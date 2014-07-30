SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftGetJobNextStatusStage] (
	@JobNumber varchar(20)
)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @StatusStage varchar(50)

	SELECT @StatusStage = StatusStage 
	FROM vwJobsStatusA
	WHERE (JobNumber = @JobNumber)

	SELECT @StatusStage = CASE (@StatusStage) 
									WHEN 'Editor' THEN 'QA1' 
									WHEN 'QA1' THEN 'QA2' 
									WHEN 'QA2' THEN 'CR' 
									ELSE '' 
							END
  
	RETURN @StatusStage
END
GO
