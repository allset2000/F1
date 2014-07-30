SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getMedicalJobB] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.vwMedicalJobsB
    WHERE (JobNumber = @JobNumber)
RETURN

GO
