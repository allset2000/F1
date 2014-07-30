SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ftGetJobStatus] (	
	@JobNumber varchar(20)
)
RETURNS TABLE 
AS
RETURN (
	SELECT * FROM JobStatusA 
	WHERE JobNumber = @JobNumber	
	
	UNION
	 
	SELECT * FROM JobStatusB
	WHERE JobNumber = @JobNumber	
)
GO
