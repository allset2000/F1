SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_GetSummaryByClinicOrDictator]
	@ClinicName varchar(50),
	@DictatorID varchar(50)
AS
BEGIN
	IF(@ClinicName <> '' AND @DictatorID = '')
	BEGIN
		SELECT Dashboard.Dashboard_Id, d_board.numjobs 
		FROM (SELECT StatusJob, COUNT(*) AS numjobs       
			  FROM (SELECT Jobs.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 THEN 5 END AS StatusJob 
					FROM   Jobs INNER JOIN JobStatusA ON Jobs.JobNumber = JobStatusA.JobNumber 
								INNER JOIN Clinics ON Jobs.ClinicID = Clinics.ClinicID 
								INNER JOIN Dictators ON Jobs.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA.Status < 170) AND (Jobs.Stat = '0') AND (Clinics.ClinicName = @ClinicName)
					WHERE (JobStatusA.Status BETWEEN 100 AND 235) AND (Jobs.Stat = '0') AND (Clinics.ClinicName = @ClinicName) 
					UNION 
					SELECT Jobs_1.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) <= 60 THEN 6 
						 WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) > 60 THEN 7 END AS StatusJob 
					FROM   Jobs AS Jobs_1 INNER JOIN JobStatusA AS JobStatusA_1 ON Jobs_1.JobNumber = JobStatusA_1.JobNumber 
										  INNER JOIN Clinics AS Clinics ON Jobs_1.ClinicID = Clinics.ClinicID 
										  INNER JOIN Dictators AS Dictators ON Jobs_1.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA_1.Status < 170) AND (Jobs_1.Stat = '1') AND (Clinics.ClinicName = @ClinicName)) AS foo 
					WHERE (JobStatusA_1.Status BETWEEN 100 AND 235) AND (Jobs_1.Stat = '1') AND (Clinics.ClinicName = @ClinicName)) AS foo 
			  GROUP BY StatusJob) AS d_board RIGHT OUTER JOIN Dashboard ON d_board.StatusJob = Dashboard.Dashboard_Id 
	END
	ELSE IF(@ClinicName = '' AND @DictatorID <> '')
	BEGIN
		SELECT Dashboard.Dashboard_Id, d_board.numjobs 
		FROM (SELECT StatusJob, COUNT(*) AS numjobs       
			  FROM (SELECT Jobs.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 THEN 5 END AS StatusJob 
					FROM   Jobs INNER JOIN JobStatusA ON Jobs.JobNumber = JobStatusA.JobNumber 
								INNER JOIN Clinics ON Jobs.ClinicID = Clinics.ClinicID 
								INNER JOIN Dictators ON Jobs.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA.Status < 170) AND (Jobs.Stat = '0') AND (Dictators.DictatorID = @DictatorID)
					WHERE (JobStatusA.Status BETWEEN 100 AND 235) AND (Jobs.Stat = '0') AND (Dictators.DictatorID = @DictatorID)
					UNION 
					SELECT Jobs_1.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) <= 60 THEN 6 
						 WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) > 60 THEN 7 END AS StatusJob 
					FROM   Jobs AS Jobs_1 INNER JOIN JobStatusA AS JobStatusA_1 ON Jobs_1.JobNumber = JobStatusA_1.JobNumber 
										  INNER JOIN Clinics AS Clinics ON Jobs_1.ClinicID = Clinics.ClinicID 
										  INNER JOIN Dictators AS Dictators ON Jobs_1.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA_1.Status < 170) AND (Jobs_1.Stat = '1') AND (Dictators.DictatorID = @DictatorID)) AS foo 
					WHERE (JobStatusA_1.Status BETWEEN 100 AND 235) AND (Jobs_1.Stat = '1') AND (Dictators.DictatorID = @DictatorID)) AS foo 
			  GROUP BY StatusJob) AS d_board RIGHT OUTER JOIN Dashboard ON d_board.StatusJob = Dashboard.Dashboard_Id 
	END
	ELSE IF(@ClinicName <> '' AND @DictatorID <> '')
	BEGIN
		SELECT Dashboard.Dashboard_Id, d_board.numjobs 
		FROM (SELECT StatusJob, COUNT(*) AS numjobs       
			  FROM (SELECT Jobs.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 THEN 5 END AS StatusJob 
					FROM   Jobs INNER JOIN JobStatusA ON Jobs.JobNumber = JobStatusA.JobNumber 
								INNER JOIN Clinics ON Jobs.ClinicID = Clinics.ClinicID 
								INNER JOIN Dictators ON Jobs.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA.Status < 170) AND (Jobs.Stat = '0') AND (Clinics.ClinicName = @ClinicName) AND (Dictators.DictatorID = @DictatorID)
					WHERE (JobStatusA.Status BETWEEN 100 AND 235) AND (Jobs.Stat = '0') AND (Clinics.ClinicName = @ClinicName) AND (Dictators.DictatorID = @DictatorID)
					UNION 
					SELECT Jobs_1.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) <= 60 THEN 6 
						 WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) > 60 THEN 7 END AS StatusJob 
					FROM   Jobs AS Jobs_1 INNER JOIN JobStatusA AS JobStatusA_1 ON Jobs_1.JobNumber = JobStatusA_1.JobNumber 
										  INNER JOIN Clinics AS Clinics ON Jobs_1.ClinicID = Clinics.ClinicID 
										  INNER JOIN Dictators AS Dictators ON Jobs_1.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA_1.Status < 170) AND (Jobs_1.Stat = '1') AND (Clinics.ClinicName = @ClinicName) AND (Dictators.DictatorID = @DictatorID)) AS foo 
					WHERE (JobStatusA_1.Status BETWEEN 100 AND 235) AND (Jobs_1.Stat = '1') AND (Clinics.ClinicName = @ClinicName) AND (Dictators.DictatorID = @DictatorID)) AS foo 
			  GROUP BY StatusJob) AS d_board RIGHT OUTER JOIN Dashboard ON d_board.StatusJob = Dashboard.Dashboard_Id 
	END
	ELSE
	BEGIN
		SELECT Dashboard.Dashboard_Id, d_board.numjobs 
		FROM (SELECT StatusJob, COUNT(*) AS numjobs       
			  FROM (SELECT Jobs.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4 
						 WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 THEN 5 END AS StatusJob 
					FROM   Jobs INNER JOIN JobStatusA ON Jobs.JobNumber = JobStatusA.JobNumber 
								INNER JOIN Clinics ON Jobs.ClinicID = Clinics.ClinicID 
								INNER JOIN Dictators ON Jobs.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA.Status < 170) AND (Jobs.Stat = '0') 
					WHERE (JobStatusA.Status BETWEEN 100 AND 235) AND (Jobs.Stat = '0') 
					UNION 
					SELECT Jobs_1.JobNumber, 
					CASE WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) <= 60 THEN 6 
						 WHEN DATEDIFF(minute, Jobs_1.ReceivedOn, GETDATE()) > 60 THEN 7 END AS StatusJob 
					FROM   Jobs AS Jobs_1 INNER JOIN JobStatusA AS JobStatusA_1 ON Jobs_1.JobNumber = JobStatusA_1.JobNumber 
										  INNER JOIN Clinics AS Clinics ON Jobs_1.ClinicID = Clinics.ClinicID 
										  INNER JOIN Dictators AS Dictators ON Jobs_1.DictatorID = Dictators.DictatorID 
					--WHERE (JobStatusA_1.Status < 170) AND (Jobs_1.Stat = '1')) AS foo 
					WHERE (JobStatusA_1.Status BETWEEN 100 AND 235) AND (Jobs_1.Stat = '1')) AS foo 
			  GROUP BY StatusJob) AS d_board RIGHT OUTER JOIN Dashboard ON d_board.StatusJob = Dashboard.Dashboard_Id 
	END
END
GO
