SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | get image only jobs
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobsGet 210, 300, 1, 0, 0
*/

CREATE PROCEDURE [dbo].[sp_JobsGet] 
	@ClinicID bigint,
	@Status smallint,
	@HasImages bit,	
	@HasChatHistory bit,
	@HasDictation bit

	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT Jobs.JobID, Jobs.JobNumber, JobTypes.Name as JobType, Encounters.AppointmentDate, 'pdf' as DocumentFormat,
                                Patients.MRN, Patients.FirstName, Patients.LastName, Jobs.JobNumber AS ClientJobNumber, Schedules.AppointmentID, 
                                Schedules.EHREncounterID, Schedules.ScheduleID, Jobs.JobID as HostedJobId, Jobs.EncounterID, Dictators.DictatorName as DictatorID, Dictators.EHRProviderAlias, Dictators.EHRProviderID,                                
                                JobTypes.TddEnabled as IsExpressNote, JobTypes.EHRDocumentTypeID, JobTypes.EHRImageTypeId, JobTypes.AllowEncounterSearch, JobTypes.AllowNotifications, JobTypes.DocumentType, JobTypes.ACKEnabled
                                FROM Jobs INNER JOIN JobTypes ON Jobs.JobTypeID = JobTypes.JobTypeID                                
                                LEFT OUTER JOIN Encounters ON Encounters.EncounterID = Jobs.EncounterID
                                INNER JOIN Patients ON Patients.PatientID = Encounters.PatientID                                 
                                LEFT OUTER JOIN Schedules ON Schedules.ScheduleID = Encounters.ScheduleID
                                LEFT OUTER JOIN Dictators ON Dictators.DictatorID = Jobs.DictatorID                                 
                                WHERE Jobs.ClinicID = @ClinicID and Jobs.[Status] = @Status and ISNULL(jobs.hasImages, 0) = @HasImages and ISNULL(jobs.hasDictation, 0) = @HasDictation and ISNULL(jobs.HasChatHistory,0) = @HasChatHistory
								and Jobs.Jobid = 838920 
END
GO
