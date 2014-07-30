SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[getJobCustom] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.Jobs_Custom
    WHERE (JobNumber = @JobNumber)
RETURN
GO
