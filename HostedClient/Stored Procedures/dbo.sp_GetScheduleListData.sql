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
	SET @CurrentPlace = @CurrentPage * @SelectSize
	SET @DaysForward = @DaysForward + 1 -- need to add 1 to ensure daysforward is correct
	SET @DaysPast = @DaysPast * -1
	SET @StartDate = DATEADD(day,@DaysPast,@AppointmentDate)
	SET @EndApptDate = DATEADD(day,@DaysForward,@AppointmentDate)

	CREATE TABLE #tmp_resourceids
	(
		ResourceId INT
	)

	INSERT INTO #tmp_resourceids
	SELECT * FROM split (@ResourceIds, ',')

	IF (@LastSync is not null)
	BEGIN
		SELECT ScheduleId, FirstName, MI, LastName, MRN, ReasonForVisit, AppointmentDate, AppointmentStatus, JobId, JobStatus, JobNumber
    	FROM (
			SELECT	S.ScheduleId, 
					P.FirstName, 
					P.MI, 
					P.LastName, 
					P.MRN, 
					S.ReasonName as 'ReasonForVisit', 
					S.AppointmentDate,
					S.Status as 'AppointmentStatus', 
					J.JobId, 
					J.Status as 'JobStatus', 
					J.JobNumber,
					S.ChangedOn
			FROM Schedules S 
				INNER JOIN Patients P on P.PatientID = S.PatientID
				INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
				LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
				LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId
			WHERE S.Clinicid = @ClinicId
				  and S.AppointmentDate >= @StartDate
				  and S.AppointmentDate <= @EndApptDate
			Order By S.Changedon DESC
			OFFSET @CurrentPlace ROWS
			FETCH NEXT @SelectAmount ROWS ONLY
		) X
		WHERE X.Changedon >= @LastSync
		ORDER BY AppointmentDate
	END
	ELSE
	BEGIN
		SELECT	S.ScheduleId, 
				P.FirstName, 
				P.MI, 
				P.LastName, 
				P.MRN, 
				S.ReasonName as 'ReasonForVisit', 
				S.AppointmentDate,
				S.Status as 'AppointmentStatus', 
				J.JobId, 
				J.Status as 'JobStatus', 
				J.JobNumber 
		FROM Schedules S 
			INNER JOIN Patients P on P.PatientID = S.PatientID
			INNER JOIN #tmp_resourceids TR on TR.ResourceId = S.ResourceId
			LEFT OUTER JOIN Encounters E on E.ScheduleId = S.ScheduleId
			LEFT OUTER JOIN Jobs J on J.EncounterId = E.EncounterId 
		WHERE S.Clinicid = @ClinicId
				and S.AppointmentDate >= @StartDate
				and S.AppointmentDate <= @EndApptDate
		Order By S.AppointmentDate,S.Changedon DESC
		OFFSET @CurrentPlace ROWS
		FETCH NEXT @SelectAmount ROWS ONLY
	END

	DROP TABLE #tmp_resourceids

END


GO
