SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/13/2014
-- Description: SP used to pull schedule messages to display in AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSchedulesForSearch] (
	@ClinicId int,
	@MRN varchar(100),
	@LastName varchar(100),
	@FirstName varchar(100),
	@Provider varchar(100),
	@Location varchar(100),
	@Reason varchar(100),
	@StartDate varchar(100),
	@EndDate varchar(100)
) AS 
BEGIN
	DECLARE @SQL_STRING varchar(1000)
	
	SET @SQL_STRING = 'SELECT ScheduleID, AppointmentID, AppointmentDate, P.MRN, P.FirstName as PatientFirstName, P.LastName as PatientLastName, P.DOB as PatientDOB, S.ResourceName, S.LocationID, S.LocationName, S.ReasonID, S.ReasonName, S.Status, S.ChangedOn from Schedules S INNER JOIN Patients P on P.PatientID = S.PatientID'
	SET @SQL_STRING = @SQL_STRING + ' WHERE S.ClinicId = ' + CAST(@ClinicId as varchar(10))
	
	IF(LEN(@MRN) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and P.MRN=''' + @MRN + ''''
	END
	IF(LEN(@LastName) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and P.LastName LIKE ''%' + @LastName + '%'''
	END
	IF(LEN(@FirstName) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and P.FirstName LIKE ''%' + @FirstName + '%'''
	END
	IF(LEN(@Provider) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and S.ResourceName LIKE ''%' + @Provider + '%'''
	END
	IF(LEN(@Location) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and S.LocationName LIKE ''%' + @Location + '%'''
	END
	IF(LEN(@Reason) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and S.ReasonName LIKE ''%' + @Reason + '%'''
	END
	IF(@StartDate is not null)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and S.AppointmentDate >= ''' + @StartDate + ''''
	END
	IF(@EndDate is not null)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and S.AppointmentDate <= ''' + @EndDate + ''''
	END
		
	SET @SQL_STRING = @SQL_STRING + ' ORDER BY S.ScheduleID'
	
	EXEC (@SQL_STRING)
	
END


GO
