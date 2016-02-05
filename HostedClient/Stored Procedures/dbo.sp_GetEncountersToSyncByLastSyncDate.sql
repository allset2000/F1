
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
--exec sp_GetEncountersToSyncByLastSyncDate 2196 ,'2014-11-20 10:15:02.970','2015-05-04 00:00:00.000','next'
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
	 
   StartPoint: --Don't delete this string we are using this for repetition task Up to 7
 
	  INSERT INTO @TempEncounter
	  SELECT DISTINCT e.EncounterID AS ID, 
			 DATEDIFF(SECOND,{D '1970-01-01'}, e.AppointmentDate) AS AppointmentDate ,			
			 e.PatientID, 
			 e.ScheduleID,
			 CASE WHEN q.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 STUFF((SELECT ', ' + CAST(JobID AS VARCHAR)
				  FROM   dbo.Jobs j2 
				  WHERE  j2.EncounterID = e.EncounterID                   
				  FOR XML PATH('')), 1, 2, '')  JobDetails
		 FROM dbo.Encounters e
				INNER	JOIN dbo.Jobs j ON j.EncounterID=e.EncounterID
				INNER JOIN dbo.Dictations d ON d.JobID=j.JobID	
				INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
				INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
				LEFT JOIN dbo.Schedules s ON s.ScheduleID=e.ScheduleID
				LEFT JOIN dbo.Patients p ON p.PatientID=e.PatientID
		WHERE qu.DictatorID = @DictatorId AND 
		     CAST(e.AppointmentDate AS DATE)=(CASE WHEN @AppointmentDate IS NOT NULL 
							THEN CAST(@AppointmentDate AS DATE) ELSE CAST(e.AppointmentDate AS DATE) END) AND 	       
			  d.[Status] IN (100, 200) AND 			  
			  (ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			   OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (e.PatientID IS NOT NULL AND ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   )

    
	    --this loic for repeat the task upto 7 times,and it will only if direction value come as a next or prev
	      IF (NOT EXISTS(SELECT	'*' FROM @TempEncounter) AND (ISNULL(@Direction,'')<>'' ))
		    BEGIN			

			   SELECT @AppointmentDate=(CASE WHEN @Direction='prev' THEN MAX(e.AppointmentDate) ELSE MIN (e.AppointmentDate) END) 
				 FROM dbo.Encounters e
						INNER	JOIN dbo.Jobs j ON j.EncounterID=e.EncounterID
						INNER JOIN dbo.Dictations d ON d.JobID=j.JobID	
						INNER JOIN dbo.Queue_Users AS qu ON qu.QueueID = d.QueueID 
						INNER JOIN dbo.Queues AS q ON q.QueueID = qu.QueueID
						LEFT JOIN dbo.Schedules s ON s.ScheduleID=e.ScheduleID
						LEFT JOIN dbo.Patients p ON p.PatientID=e.PatientID
				WHERE qu.DictatorID = @DictatorId AND 
		     	      @AppointmentDate<=(CASE WHEN @Direction='next' THEN e.AppointmentDate else @AppointmentDate END) AND
					  @AppointmentDate>=(CASE WHEN @Direction='prev' THEN e.AppointmentDate else @AppointmentDate END) AND
					  d.[Status] IN (100, 200) AND 			  
					  (ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
					   OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
					   OR (e.PatientID IS NOT NULL AND ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
					   OR (ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			           )

            --if there is appointment date for previous or next it this value comes has a null
			 IF(@AppointmentDate IS NOT NULL)			  
				  GOTO StartPoint; --this step goto the start position and repeat the task

			END
	 

	SELECT ID, AppointmentDate, PatientID, ScheduleID, [State], JobDetails  FROM @TempEncounter   


END




GO
