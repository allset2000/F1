SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ftGetStatusID] (
	@StatusClass varchar(50),
  @StatusStage varchar(50)	
)
RETURNS smallint
AS
BEGIN
	DECLARE @StatusID smallint

	SELECT @StatusID = StatusID
	FROM StatusCodes
	WHERE (StatusClass = @StatusClass) AND (StatusStage = @StatusStage)

	RETURN @StatusID
END
GO
