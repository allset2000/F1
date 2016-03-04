
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
--exec sp_GetEncountersToSyncByLastSyncDate 905 ,'2014-11-20 10:15:02.970',NULL,NULL
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
					FROM dbo.Encounters e
						INNER	JOIN dbo.Jobs j ON j.EncounterID=e.EncounterID
						INNER JOIN dbo.Dictations d ON d.JobID=j.JobID	
						INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
						INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID							
				WHERE qu.DictatorID = @DictatorId AND 
		     			CAST(@AppointmentDate AS DATE)<=(CASE WHEN @Direction='next' THEN CAST(e.AppointmentDate AS DATE) else @AppointmentDate END) AND
						CAST(@AppointmentDate AS DATE)>=(CASE WHEN @Direction='prev' THEN CAST(e.AppointmentDate AS DATE) else @AppointmentDate END) AND
						d.[Status] IN (100, 200)

				

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
			 p.PatientID, 
			 e.ScheduleID,
			 CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 STUFF((SELECT ', ' + CAST(JobID AS VARCHAR)
				  FROM   dbo.Jobs j2 
				  WHERE  j2.EncounterID = e.EncounterID                   
				  FOR XML PATH('')), 1, 2, '')  JobDetails,
				  e.AppointmentDate as ADate
		 FROM dbo.Encounters e
				INNER JOIN dbo.Jobs j ON j.EncounterID=e.EncounterID
				INNER JOIN dbo.Dictations d ON d.JobID=j.JobID	
				INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Schedules s ON s.ScheduleID=e.ScheduleID
				LEFT JOIN dbo.Patients p ON p.PatientID=e.PatientID
		WHERE qu.DictatorID = @DictatorId AND 
		     CAST(e.AppointmentDate AS DATE)=(CASE WHEN @AppointmentDate IS NOT NULL 
							THEN @AppointmentDate  ELSE CAST(e.AppointmentDate AS DATE) END) AND 	       
			  d.[Status] IN (100, 200) AND 			  
			  (ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			   OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (e.PatientID IS NOT NULL AND ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   )



END




GO
