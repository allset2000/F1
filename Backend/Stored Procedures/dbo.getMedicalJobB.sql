SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getMedicalJobB] (
   @JobNumber varchar(20)
) AS
	--SELECT *
	--FROM   dbo.vwMedicalJobsB
	--WHERE (JobNumber = @JobNumber)
     
    SELECT vMJB.*,JA.DocumentArchivedOn, JA.FileArchivedOn,JA.DocumentPurgedOn 
	FROM   dbo.vwMedicalJobsB vMJB
	left join Jobs_ArchiveDetails JA on vMJB.JobNumber = JA.JobNumber 
	WHERE (vMJB.JobNumber = @JobNumber)
	
RETURN

GO
