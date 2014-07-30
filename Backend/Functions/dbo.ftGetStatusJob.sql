SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftGetStatusJob] (
	@JobNumber varchar(20)
)
RETURNS smallint
AS
BEGIN
	DECLARE @StatusJob smallint

	SELECT @StatusJob = [Status]
	FROM JobStatusA
	WHERE (JobNumber = @JobNumber)

	RETURN @StatusJob
END
GO
