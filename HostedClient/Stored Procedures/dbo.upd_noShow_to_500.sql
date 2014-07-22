SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Isaac Swindle
-- Create date: 6/6/2014
-- Description:	Updates [Jobs] / [Dictations] Status columns
--				to 500 if:
--							Appointment Date is today
--							Appointment Status is 100 
--							Job Status is 100
--							JobType is NoShowEnabled
--				Executed by SQL Job at end of day			
-- =============================================
CREATE PROCEDURE [dbo].[upd_noShow_to_500]
AS
BEGIN

	SET NOCOUNT ON;

    	SELECT j.[JobID]
      ,j.[JobNumber]
      ,j.[ClinicID]
      ,j.[EncounterID]
      ,j.[JobTypeID]
      ,j.[OwnerDictatorID]
      ,j.[Status] AS JobStatus
	  ,s.[AppointmentDate] AS ApptDate
	  ,s.[Status] AS ApptStatus
	FROM [EntradaDB].[dbo].[Jobs] j 
		INNER JOIN Dictations d ON d.JobID = j.JobID
		INNER JOIN Encounters e	ON j.EncounterID = e.EncounterID
		INNER JOIN Schedules s	ON e.ScheduleID = s.ScheduleID 
	WHERE j.[Status] = '100'
		AND JobTypeID IN(	Select JobTypeID 
							From JobTypes 
							Where NoShowEnabled = '1')

/*	
	DECLARE @ApptDate DATE = Cast(GetDate() AS Date)

	Update Jobs
	Set Status = '500'
	FROM [EntradaDB].[dbo].[Jobs] j 
		INNER JOIN Dictations d ON d.JobID = j.JobID
		INNER JOIN Encounters e	ON j.EncounterID = e.EncounterID
		INNER JOIN Schedules s	ON e.ScheduleID = s.ScheduleID 
	WHERE	j.[Status] = '100'
			AND JobTypeID IN(	Select JobTypeID 
								From JobTypes 
								Where NoShowEnabled = '1')
			AND s.Status = '100'
			AND Cast(s.AppointmentDate AS Date) = @ApptDate
			

	Update Dictations
	Set Status = '500'
	FROM [EntradaDB].[dbo].[Dictations] d 
		INNER JOIN Jobs J ON d.JobID = j.JobID
		INNER JOIN Encounters e	ON j.EncounterID = e.EncounterID
		INNER JOIN Schedules s	ON e.ScheduleID = s.ScheduleID 
	WHERE	j.[Status] = '100'
			AND JobTypeID IN(	Select JobTypeID 
								From JobTypes 
								Where NoShowEnabled = '1')
			AND s.Status = '100'
			AND Cast(s.AppointmentDate AS Date) = @ApptDate


*/
END
GO
