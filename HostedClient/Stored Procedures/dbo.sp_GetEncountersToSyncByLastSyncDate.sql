
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014,3/27/2016
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
--Generic patient details issue fixed
--exec sp_GetEncountersToSyncByLastSyncDate 3514 ,'2013-11-20 10:15:02.970','2016-02-20','next'
--exec sp_GetEncountersToSyncByLastSyncDate 2916 ,'2013-11-20 10:15:02.970','2016-02-23','next'


-- =============================================
CREATE PROCEDURE [dbo].[sp_GetEncountersToSyncByLastSyncDate](
	 @DictatorId INT,
	 @LastSyncDate DATETIME,
	 @AppointmentDate DATETIME,
	 @Direction VARCHAR(20)
) AS 
BEGIN
     SET NOCOUNT ON;
	   DECLARE @TempEncounter AS TABLE	
				(ID INT,
				 AppointmentDate INT,
				 PatientID INT,
				 ScheduleID INT,
				 [State] INT,
				 JobDetails VARCHAR(2000)
				)

  if(@AppointmentDate IS NOT NULL)
    SET @AppointmentDate=CAST(@AppointmentDate AS DATE)

	DECLARE @RecourdCount INT
	 
	 --if appointment date and direction both have data then check count value on that date if not exists then take next appointment of prev or next
    IF(ISNULL(@Direction,'')<>'')
	  BEGIN
	        
				SELECT @AppointmentDate=(CASE WHEN @Direction='prev' THEN MAX(e.AppointmentDate) ELSE MIN (e.AppointmentDate) END) 
					FROM dbo.Encounters e WITH(NOLOCK)
						INNER JOIN dbo.Jobs j WITH(NOLOCK) ON j.EncounterID=e.EncounterID
						LEFT JOIN dbo.Dictations d WITH(NOLOCK) ON d.JobID=j.JobID	
						LEFT JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID 
						LEFT JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID							
				WHERE-- qu.DictatorID = @DictatorId AND d.[Status] IN (100, 200) 
					((j.Status in (100,500) AND qu.DictatorID = @DictatorId) OR (j.Status NOT IN(100,500) AND 
							  (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID)))  
		     		AND @AppointmentDate<=(CASE WHEN @Direction='next' THEN CAST(e.AppointmentDate AS DATE) else @AppointmentDate END) 
					AND	@AppointmentDate>=(CASE WHEN @Direction='prev' THEN CAST(e.AppointmentDate AS DATE) else @AppointmentDate END)
						

			

			   --IF appointment date is null then return as Empty result 
				IF (@AppointmentDate IS NULL)
				  BEGIN
				    SELECT ID, AppointmentDate, PatientID, ScheduleID, [State], JobDetails  FROM @TempEncounter   
					RETURN
				  END
        END


	--  INSERT INTO @TempEncounter
     SELECT DISTINCT e.EncounterID AS ID, 
			 DATEDIFF(SECOND,{D '1970-01-01'}, e.AppointmentDate) AS AppointmentDate ,			
			 CASE WHEN E.PatientID=SS.GenericPatientID THEN NULL ELSE P.PatientID END AS PatientID,
			 e.ScheduleID,
			 CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 STUFF((SELECT ', ' + CAST(JobID AS VARCHAR)
				  FROM   dbo.Jobs j2 
				  WHERE  j2.EncounterID = e.EncounterID                   
				  FOR XML PATH('')), 1, 2, '')  JobDetails			
		 FROM dbo.Encounters e WITH(NOLOCK)
				INNER JOIN dbo.Jobs j WITH(NOLOCK) ON j.EncounterID=e.EncounterID
				LEFT JOIN dbo.Dictations d WITH(NOLOCK) ON d.JobID=j.JobID	
				LEFT JOIN dbo.Queue_Users AS qu WITH(NOLOCK) ON qu.QueueID = d.QueueID 
				LEFT JOIN dbo.Queues AS q WITH(NOLOCK) ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Patients p WITH(NOLOCK) ON p.PatientID=e.PatientID
				LEFT JOIN dbo.Schedules s WITH(NOLOCK) ON s.ScheduleID=e.ScheduleID
				LEFT JOIN [SystemSettings] SS on SS.ClinicID=P.ClinicID and E.PatientID=SS.GenericPatientID
		WHERE  --qu.DictatorID = @DictatorId AND d.[Status] IN (100, 200)  
			((j.Status in (100,500) AND qu.DictatorID = @DictatorId) OR (j.Status NOT IN(100,500) AND 
							  (d.DictatorID=@DictatorID OR j.OwnerDictatorID=@DictatorID)))
		    AND CAST(e.AppointmentDate AS DATE)=(CASE WHEN @AppointmentDate IS NOT NULL 
							THEN  CAST(@AppointmentDate AS DATE)  ELSE CAST(e.AppointmentDate AS DATE) END)    
			AND (ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			   OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (e.PatientID IS NOT NULL AND ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   )

END




GO
