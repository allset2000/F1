
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014,3/27/2016
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
--Generic patient details issue fixed
--Modified:Raghu A--18/04/2016--Update proc for get completed jobs encounters
--exec sp_GetEncountersToSyncByLastSyncDate 1045 ,'2013-11-20 10:15:02.970','2016-02-20','prev'
--exec sp_GetEncountersToSyncByLastSyncDate_A 3514 ,'2013-11-20 10:15:02.970','2016-02-23','prev'
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
	        
					declare @SQL nvarchar(max) = '',
						@Parms nvarchar(max) = '@AppointmentDate datetime output,@DictatorId BigInt'

				 SET @SQL = 'SELECT @AppointmentDate='+CASE WHEN @Direction='prev' then 'max(e.appointmentdate)'else' Min(e.appointmentdate)'END +'
					        FROM Encounters E With(Nolock)
							INNER JOIN 
									(
									-- get completed jobs list match with owner dictatorID
									SELECT j.JobID,J.EncounterID
									FROM 
										dbo.Jobs j WITH(NOLOCK)
									 WHERE j.Status NOT IN(100,500)  
									   AND j.OwnerDictatorID=@DictatorId
									 
								UNION
								--get all jobs list match with dictation dictatorID
									 SELECT j.JobID,J.EncounterID								 
									 FROM
									  DBO.Jobs J WITH(NOLOCK) 
									 INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
									 INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
									 INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
									 WHERE  QU.DictatorID=@DictatorId
									 
									)A on A.EncounterID=E.EncounterID
							WHERE  @AppointmentDate ' + CASE WHEN @Direction='next' then ' <= CAST(e.AppointmentDate AS DATE)'  else '>= CAST(e.AppointmentDate AS DATE)' END  + '
								
								'
	
					exec sp_executesql @SQl, @Parms, @AppointmentDate = @AppointmentDate output, @DictatorID = @DictatorID

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
			 CASE WHEN A.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 STUFF((SELECT ', ' + CAST(JobID AS VARCHAR)
				  FROM   dbo.Jobs j2 With(Nolock)  
				  WHERE  j2.EncounterID = e.EncounterID                   
				  FOR XML PATH('')), 1, 2, '')  JobDetails			
		 FROM dbo.Encounters e WITH(NOLOCK)
				INNER JOIN dbo.Jobs j WITH(NOLOCK) ON j.EncounterID=e.EncounterID
				INNER JOIN 
				      ( 
					      -- get completed jobs list match with owner dictatorID
							SELECT j.JobID,J.EncounterID,0 AS Deleted
							FROM 
								dbo.Jobs j WITH(NOLOCK)
								WHERE j.Status NOT IN(100,500)  
								AND j.OwnerDictatorID=@DictatorId 
						UNION
						  --get all jobs list match with dictation dictatorID
								SELECT j.JobID,J.EncounterID,
									CASE WHEN j.Status NOT IN(100,500) THEN 0 ELSE q.Deleted END AS Deleted
								FROM
								DBO.Jobs J WITH(NOLOCK) 
								INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
								INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
								INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
								WHERE  QU.DictatorID=@DictatorId

					)A on a.EncounterID=e.EncounterID and A.JobID=j.JobID
				LEFT JOIN dbo.Patients p WITH(NOLOCK) ON p.PatientID=e.PatientID
				LEFT JOIN dbo.Schedules s WITH(NOLOCK) ON s.ScheduleID=e.ScheduleID
				LEFT JOIN [SystemSettings] SS on SS.ClinicID=P.ClinicID and E.PatientID=SS.GenericPatientID
		WHERE  CAST(e.AppointmentDate AS DATE)= CAST(@AppointmentDate AS DATE)   
			AND (ISNULL(e.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
			   OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (e.PatientID IS NOT NULL AND ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   OR (ISNULL(j.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
			   )

END




GO
