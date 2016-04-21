
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull patients to sync
--exec sp_GetPatientsToSyncByLastSyncDate 3526,'2013-04-14 17:46:12.200','2016-04-15'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientsToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME,
	 @AppointmentDate DATETIME=NULL
) AS 
BEGIN
		SET NOCOUNT ON;

		      DECLARE @GenericPatientID INT

			  SELECT @GenericPatientID=GenericPatientID 
			  FROM SystemSettings SS WITH(NOLOCK) 
			  INNER JOIN Dictators D  WITH(NOLOCK)  on D.ClinicID=SS.ClinicID
			  WHERE D.DictatorID = @DictatorId
		 
   
			 SELECT DISTINCT p.PatientID AS ID, 
					CASE WHEN a.Deleted = 1 THEN 500 ELSE 100 END AS [State],
					p.MRN, 
					p.DOB, 
					p.FirstName, 
					p.LastName, 
					p.Suffix,
					p.Gender, 
					p.Address1+', '+p.City+', '+p.State+', '+p.Zip AS [Address],
					p.Phone1,
					p.PrimaryCareProviderID ,
					e.EncounterID
			FROM dbo.Patients  AS p WITH(NOLOCK)
				INNER JOIN dbo.Encounters AS e WITH(NOLOCK) ON p.PatientID = e.PatientID
				INNER JOIN dbo.Jobs AS j WITH(NOLOCK) ON e.EncounterID = j.EncounterID
				INNER JOIN ( 
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
							)A on A.JobID=j.JobID and a.EncounterID=e.EncounterID
				LEFT JOIN dbo.Schedules AS s WITH(NOLOCK) ON s.ScheduleId = e.ScheduleId

			WHERE  e.PatientID <>@GenericPatientID AND
			       CAST(e.AppointmentDate AS DATE)=(CASE WHEN @AppointmentDate IS NOT NULL THEN  CAST(@AppointmentDate AS DATE)  ELSE CAST(e.AppointmentDate AS DATE) END) AND 
				    (  (ISNULL(P.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate) 
					OR (ISNULL(J.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
					OR (e.ScheduleID  IS NOT NULL AND ISNULL(s.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
					OR (ISNULL(E.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate)
					)
END
GO
