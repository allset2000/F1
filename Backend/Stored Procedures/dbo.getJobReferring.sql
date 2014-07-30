SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getJobReferring] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.Jobs_Referring
    WHERE (JobNumber = @JobNumber)
RETURN
GO
