SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 4/14/2015
-- Description: SP used to pull a scheduleData from the search criteria sent in
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleDataBySearch] (
	 @SearchData varchar(100),
	 @DictatorId int,
  	 @ResourceIds VARCHAR(1000) = null

) AS 
BEGIN
	DECLARE @ClinicId INT
	DECLARE @StartDate datetime
	DECLARE @EndApptDate datetime

	SET @ClinicId = (select clinicid from dictators where dictatorid = @DictatorId)

	CREATE TABLE #tmp_resourceids
	(
		ResourceId VARCHAR(100)
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	IF ((select count(*) from #tmp_resourceids) > 0)
	BEGIN
		IF ISDATE(@SearchData) = 1
		BEGIN
			SET @StartDate = (select convert(datetime, @SearchData))
			SET @EndApptDate = (select DATEADD(day,1,@StartDate))

			SELECT	S.ScheduleID, 
					S.ResourceID,
					P.PatientID,
					S.ReasonName,
					S.Status as 'AppointmentStatus', 
					CASE WHEN J.Jobid is null THEN 'null' ELSE CAST(J.JobId as varchar(10)) END as JobId,
					S.AppointmentDate
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
				LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId 
			WHERE S.Clinicid = @ClinicId
					and S.AppointmentDate >= @StartDate
					and S.AppointmentDate <= @EndApptDate
					and S.Status in (0,100,200)
			Order By S.AppointmentDate
		END
		ELSE
		BEGIN
			SET @SearchData = '%' + @SearchData + '%'
			SELECT	S.ScheduleID, 
					S.ResourceID,
					P.PatientID,
					S.ReasonName,
					S.Status as 'AppointmentStatus', 
					CASE WHEN J.JobId is null THEN 'null' ELSE CAST(J.JobId as varchar(10)) END as JobId,
					S.AppointmentDate
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
				LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId 
			WHERE S.Clinicid = @ClinicId
					and S.Status in (0,100,200)
					and (P.FirstName like @SearchData or P.LastName like @SearchData or P.MRN like @SearchData)
			Order By S.AppointmentDate
		END
	END
	ELSE
	BEGIN
		IF ISDATE(@SearchData) = 1
		BEGIN
			SET @StartDate = (select convert(datetime, @SearchData))
			SET @EndApptDate = (select DATEADD(day,1,@StartDate))

			SELECT	S.ScheduleID, 
					S.ResourceID,
					P.PatientID,
					S.ReasonName,
					S.Status as 'AppointmentStatus', 
					CASE WHEN J.JobId is null THEN 'null' ELSE CAST(J.JobId as varchar(10)) END as JobId,
					S.AppointmentDate
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
				LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId 
			WHERE S.Clinicid = @ClinicId
					and S.AppointmentDate >= @StartDate
					and S.AppointmentDate <= @EndApptDate
					and S.Status in (0,100,200)
			Order By S.AppointmentDate
		END
		ELSE
		BEGIN
			SET @SearchData = '%' + @SearchData + '%'
			SELECT	S.ScheduleID, 
					S.ResourceID,
					P.PatientID,
					S.ReasonName,
					S.Status as 'AppointmentStatus', 
					CASE WHEN J.JobId is null THEN 'null' ELSE CAST(J.JobId as varchar(10)) END as JobId,
					S.AppointmentDate
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
				LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId 
			WHERE S.Clinicid = @ClinicId
					and S.Status in (0,100,200)
					and (P.FirstName like @SearchData or P.LastName like @SearchData or P.MRN like @SearchData)
			Order By S.AppointmentDate
		END
	END
END


GO
