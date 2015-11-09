
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/6/2015
-- Description: SP called from DictateAPI to pull Schedules resource id's
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetScheduleListData] (
	@ClinicId INT,
	@ResourceIds VARCHAR(1000),
	@AppointmentDate DATE,
	@CurrentPage INT,
	@SelectSize INT,
	@DaysForward INT,
	@DaysPast INT,
	@LastSync DATETIME = null
)
AS
BEGIN

	DECLARE @SelectAmount INT
	DECLARE @CurrentPlace INT
	DECLARE @StartDate DateTime
	DECLARE @EndApptDate DateTime
	SET @SelectAmount = @SelectSize * 3 -- we pull 3 pages worth of data
	SET @CurrentPlace = (@CurrentPage - 1) * @SelectSize -- Current page should start at 0 to calculate the current item its looking at
	SET @DaysForward = @DaysForward + 1 -- need to add 1 to ensure daysforward is correct
	SET @DaysPast = @DaysPast * -1
	SET @StartDate = DATEADD(day,@DaysPast,@AppointmentDate)
	SET @EndApptDate = DATEADD(day,@DaysForward,@AppointmentDate)

	/* schedules.status values
	100 - booked appointments, not checked in
	200 - checked-in
	300 - cancelled
	500 - deleted
	*/
	CREATE TABLE #tmp_resourceids
	(
		ResourceId VARCHAR(100)
	)
	CREATE TABLE #tmp_schedules
	(
		ScheduleID INT,
		ResourceID VARCHAR(1000),
		PatientID INT,
		ReasonName varchar(200),
		AppointmentStatus int,
		AppointmentDate datetime,
		JobId varchar(1000),
		Processed int
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	IF (@LastSync is not null)
	BEGIN
		INSERT INTO #tmp_schedules(ScheduleID, ResourceID, PatientID, ReasonName, AppointmentStatus, AppointmentDate, JobId, Processed)
		SELECT ScheduleID, ResourceID, PatientID, ReasonName, AppointmentStatus, AppointmentDate, JobId, 0
    	FROM (
			SELECT	S.ScheduleID, 
					S.ResourceID,
					P.PatientID, 
					S.ReasonName, 
					S.Status as 'AppointmentStatus',
					'' as JobId,
					S.Changedon,
					S.AppointmentDate
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
			WHERE S.Clinicid = @ClinicId
				  and S.AppointmentDate >= @StartDate
				  and S.AppointmentDate <= @EndApptDate
				  --and S.Status in (0,100,200) don't filter any status
			Order By S.Changedon DESC
			OFFSET @CurrentPlace ROWS
			FETCH NEXT @SelectAmount ROWS ONLY
		) X
		WHERE X.Changedon >= @LastSync
		ORDER BY AppointmentDate
	END
	ELSE
	BEGIN
		INSERT INTO #tmp_schedules(ScheduleID, ResourceID, PatientID, ReasonName, AppointmentStatus, AppointmentDate, JobId, Processed)
				SELECT	S.ScheduleID, 
				S.ResourceID,
				P.PatientID,
				S.ReasonName,
				S.Status as 'AppointmentStatus', 
				S.AppointmentDate,
				'' as JobId,
				0
		FROM Schedules S 
			INNER JOIN Patients P on P.PatientID = S.PatientID
			INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
			LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
		WHERE S.Clinicid = @ClinicId
				and S.AppointmentDate >= @StartDate
				and S.AppointmentDate <= @EndApptDate
				--and S.Status in (0,100,200) don't filter any status
		Order By S.AppointmentDate,S.Changedon DESC
		OFFSET @CurrentPlace ROWS
		FETCH NEXT @SelectAmount ROWS ONLY
	END

	WHILE EXISTS (SELECT 1 FROM #tmp_schedules WHERE Processed = 0)
	BEGIN
		DECLARE @cur_ScheduleID INT
		DECLARE @jobid_string VARCHAR(1000)

		SET @cur_ScheduleID = (SELECT TOP 1 ScheduleID from #tmp_schedules where Processed = 0)

		SELECT @jobid_string = STUFF((SELECT ',' + CAST(JobID as varchar(10)) FROM Jobs j	
										INNER JOIN Encounters e on e.EncounterId = j.EncounterId
										INNER JOIN Schedules s on s.scheduleid = e.scheduleid
									WHERE s.ScheduleID = @cur_ScheduleID FOR XML PATH('')),1,1,'')

		UPDATE #tmp_schedules SET Processed = 1, JobId = @jobid_string WHERE ScheduleID = @cur_ScheduleID
	END

	SELECT ScheduleID, ResourceID, PatientID, ReasonName, AppointmentStatus, AppointmentDate, JobId FROM #tmp_schedules

	DROP TABLE #tmp_resourceids
	DROP TABLE #tmp_schedules

END


GO
