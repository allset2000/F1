SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[getJobPatient] (
   @JobNumber varchar(20)
) AS
	SELECT *
	FROM   dbo.Jobs_Patients
    WHERE (JobNumber = @JobNumber)
RETURN
GO
