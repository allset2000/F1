SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getMedicalJob] (
   @JobNumber varchar(20)
) AS
	--SELECT *
	--FROM   dbo.vwMedicalJobs
	--WHERE (JobNumber = @JobNumber)
    
    SELECT vMJ.*,JA.DocumentArchivedOn, JA.FileArchivedOn,JA.DocumentPurgedOn 
  	FROM   dbo.vwMedicalJobs vMJ
	left join Jobs_ArchiveDetails JA on vMJ.JobNumber = JA.JobNumber 
	WHERE (vMJ.JobNumber = @JobNumber)
RETURN

GO
