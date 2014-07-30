SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[qryCRPendingJobsByClinicMessage] (
	 @MessageId int
) AS
	SELECT dbo.vwMedicalJobs.*
	FROM dbo.ClinicsMessagesRules INNER JOIN dbo.vwMedicalJobs 
	ON dbo.ClinicsMessagesRules.ClinicID = dbo.vwMedicalJobs.ClinicID 
	INNER JOIN dbo.ClinicsMessages ON 
	dbo.ClinicsMessagesRules.MessageRuleId = dbo.ClinicsMessages.MessageRuleId
	WHERE ((dbo.ClinicsMessages.MessageId = @MessageId) AND 
				(dbo.ClinicsMessagesRules.LocationID IN (0, dbo.vwMedicalJobs.Location)) AND 
	      (dbo.ClinicsMessagesRules.DictatorID IN ('', dbo.vwMedicalJobs.DictatorID)) AND 
        (dbo.ClinicsMessagesRules.JobType IN ('', dbo.vwMedicalJobs.JobType)) AND
        (dbo.ClinicsMessages.ProgrammedTime <= GETDATE())) AND
        (dbo.vwMedicalJobs.JobStatus = dbo.ftGetStatusID('JobReturned', 'QA2') OR  
         dbo.vwMedicalJobs.JobStatus = dbo.ftGetStatusID('JobAvailable', 'CR'))
RETURN

GO
