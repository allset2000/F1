SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getMedicalJob] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.vwMedicalJobs
    WHERE (JobNumber = @JobNumber)
RETURN

GO
