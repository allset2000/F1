SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/14/2014
-- Description: SP used to pull jobs to display in AC
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsForSearch] (
	@ClinicId int,
	@JobNumber varchar(100),
	@Queue varchar(100),
	@Dictatorid varchar(100),
	@Status varchar(10),
	@StatJob varchar(10),
	@JobTypeId varchar(50),
	@MRN varchar(100),
	@LastName varchar(100),
	@FirstName varchar(100),
	@StartDate varchar(100),
	@EndDate varchar(100)
) AS 
BEGIN
	DECLARE @SQL_STRING varchar(1000)
	
	SET @SQL_STRING = 'SELECT Jobs.JobId, Jobs.JobNumber, Patients.MRN, Jobs.Status, Dictators.DictatorName as DictatorName, JobTypes.JobTypeId, JobTypes.Name AS JobType, Patients.FirstName as PatientFirstName, Patients.LastName as PatientLastName FROM Jobs INNER JOIN JobTypes ON Jobs.JobTypeID = JobTypes.JobTypeID INNER JOIN Encounters ON Jobs.EncounterID = Encounters.EncounterID INNER JOIN Dictations ON Dictations.JobID = Jobs.JobId INNER JOIN Patients ON Encounters.PatientID = Patients.PatientID LEFT JOIN Queues ON Dictations.QueueID = Queues.QueueID LEFT JOIN Dictators ON Dictations.DictatorID = Dictators.DictatorID'
	SET @SQL_STRING = @SQL_STRING + ' WHERE Jobs.ClinicId = ' + CAST(@ClinicId as varchar(10))
	
	IF(LEN(@JobNumber) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and JobNumber = ''' + @JobNumber + ''''
	END
	IF(LEN(@MRN) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and MRN=''' + @MRN + ''''
	END
	IF(LEN(@LastName) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Patients.LastName LIKE ''%' + @LastName + '%'''
	END
	IF(LEN(@FirstName) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Patients.FirstName LIKE ''%' + @FirstName + '%'''
	END
	IF(LEN(@Queue) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Dictations.QueueID = ' + @Queue
	END
	IF(LEN(@Dictatorid) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Dictations.DictatorID = ' + @Dictatorid
	END
	IF(LEN(@JobTypeId) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Jobs.JobTypeID = ' + @JobTypeId
	END
	IF(LEN(@Status) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Jobs.Status = ' + @Status
	END
	IF(LEN(@StatJob) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Stat = ' + @StatJob
	END
	IF(LEN(@StartDate) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and AppointmentDate >= ''' + @StartDate + ''''
	END
	IF(LEN(@EndDate) > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and AppointmentDate <= ''' + @EndDate + ''''
	END
		
	SET @SQL_STRING = @SQL_STRING + ' ORDER BY JobNumber'
	
	EXEC (@SQL_STRING)
	
END


GO
