SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/14/2014
-- Description: SP used to mass update jobs in AC, SP returns the total number of dictations deleted
-- Usage: EXEC sp_runUpdateJobs {clinicid}, {jobnumber}, {queueid}, {dictatorid}, {status}, {stat}, {jobtypeid}, {mrn}, {lastname}, {firstname}, {startdate}, {enddate}, {updatetype}, {deletedby}
-- =============================================
CREATE PROCEDURE [dbo].[sp_runUpdateJobs] (
	@ClinicId int,
	@JobNumber varchar(100),
	@Queue int,
	@Dictatorid int,
	@Status varchar(10),
	@StatJob varchar(10),
	@JobTypeId int,
	@MRN varchar(100),
	@LastName varchar(100),
	@FirstName varchar(100),
	@StartDate varchar(100),
	@EndDate varchar(100),
	@JobUpdateType int,
	@UpdatedBy varchar(200)
) AS 
BEGIN

	CREATE TABLE #tmp_data 
	(
		JobID int,
		Processed int,
		JobTotal int
	)

	DECLARE @SQL_STRING varchar(1000)
	DECLARE @new_status int
	DECLARE @cur_status int
	
	-- Update Job to available
	IF (@JobUpdateType = 0)
	BEGIN
		SET @new_status = 100
		SET @cur_status = 500
	END
	ELSE IF (@JobUpdateType = 1)
	BEGIN
		SET @new_status = 500
		SET @cur_status = 100
	END
	
	SET @SQL_STRING = 'INSERT INTO #tmp_data SELECT Jobs.JobId, 0, 0 FROM Jobs INNER JOIN JobTypes ON Jobs.JobTypeID = JobTypes.JobTypeID INNER JOIN Encounters ON Jobs.EncounterID = Encounters.EncounterID INNER JOIN Dictations ON Dictations.JobID = Jobs.JobId INNER JOIN Patients ON Encounters.PatientID = Patients.PatientID LEFT JOIN Queues ON Dictations.QueueID = Queues.QueueID LEFT JOIN Dictators ON Dictations.DictatorID = Dictators.DictatorID'
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
	IF(@Queue > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Dictations.QueueID = ' + CAST(@Queue as varchar(10))
	END
	IF(@Dictatorid > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Dictations.DictatorID = ' + CAST(@Dictatorid as varchar(10))
	END
	IF(@JobTypeId > 0)
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Jobs.JobTypeID = ' + CAST(@JobTypeId as varchar(10))
	END
	IF(@Status != '-1')
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Jobs.Status = ' + @Status
	END
	IF(@StatJob = 'True')
	BEGIN
		SET @SQL_STRING = @SQL_STRING + ' and Stat = ''' + @StatJob + ''''
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
	
	print(@SQL_STRING)
	EXEC (@SQL_STRING)
	
	--SET @SQL_STRING  = 'UPDATE dbo.Schedules SET Rowprocessed = ' + CAST(@ReprocessType as varchar(1)) + ' WHERE ClinicId = ' + CAST(@ClinicId as varchar(10)) 
	
	WHILE EXISTS(SELECT top 1 JobId from #tmp_data where Processed = 0)
	BEGIN
	
		DECLARE @cur_jobid int
		DECLARE @cur_dictid int

		SET @cur_jobid = (SELECT top 1 jobid from #tmp_data where Processed = 0)
		SET @cur_dictid = (SELECT top 1 dictationid from Dictations where JobID = @cur_jobid and Status = @cur_status)
		
		-- Delete Job
		UPDATE Jobs SET Status = @new_status WHERE JobID = @cur_jobid
		-- Insert into JobTracking
		INSERT INTO JobsTracking(JobID, Status, ChangeDate, ChangedBy) VALUES(@cur_jobid, @new_status, GETDATE(), @UpdatedBy)
		
		-- Delete Dictation
		UPDATE Dictations SET Status = @new_status WHERE DictationID = @cur_dictid
		-- Insert into DictationTracking
		INSERT INTO DictationsTracking(DictationID, Status, ChangeDate, ChangedBy) VALUES(@cur_dictid, @new_status, GETDATE(), @UpdatedBy)
			
		UPDATE #tmp_data set Processed = 1 WHERE JobID = @cur_jobid
	END

	SELECT COUNT(*) FROM #tmp_data

	DROP TABLE #tmp_data
END
GO
