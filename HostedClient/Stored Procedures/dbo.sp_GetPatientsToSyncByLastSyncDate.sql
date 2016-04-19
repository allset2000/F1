
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 18/11/2014
-- Description: SP called from DictateAPI to pull patients to sync
-- Modified:Raghu A--18/04/2016--Update proc for get completed jobs patients
--exec sp_GetPatientsToSyncByLastSyncDate 1045,'1/1/1753 12:00:00 AM'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientsToSyncByLastSyncDate] (
	 @DictatorId INT,
	 @LastSyncDate DATETIME
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
								--Get Completed jobs
									SELECT j.JobID,J.EncounterID,0 AS Deleted,d.DictationID,NULL AS QueueID FROM 
									dbo.Jobs j WITH(NOLOCK)
									LEFT JOIN Dictations d WITH(NOLOCK) on d.JobID=j.JobID
									WHERE j.Status NOT IN(100,500)  
									AND j.OwnerDictatorID=@DictatorId 
									   
								UNION
								--Get Non Completed jobs
									 SELECT j.JobID,J.EncounterID,q.Deleted,d.DictationID,q.QueueID  FROM
									  dbo.Jobs J WITH(NOLOCK)
									 INNER JOIN Dictations D WITH(NOLOCK) ON J.JobID=D.JobID
									 INNER JOIN Queue_Users QU WITH(NOLOCK) ON QU.QueueID=D.QueueID
									 INNER JOIN Queues q WITH(NOLOCK) ON Q.QueueID=QU.QueueID
									 WHERE  j.Status In(100,500) and QU.DictatorID=@DictatorId
							)A on A.JobID=j.JobID and a.EncounterID=e.EncounterID

			WHERE  e.PatientID <>@GenericPatientID AND
				  ISNULL(p.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate
END
GO
