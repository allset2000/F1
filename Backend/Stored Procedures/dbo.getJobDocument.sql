SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getJobDocument] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.Jobs_Documents
    WHERE (JobNumber = @JobNumber)
RETURN
GO
