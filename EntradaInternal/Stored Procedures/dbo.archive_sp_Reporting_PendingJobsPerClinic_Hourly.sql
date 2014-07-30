SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/14/2012
-- Description:	Retrieves pending jobs in pivot format broken down
--		into an hourly basis.
--      If @CR = 1, omit jobs with a Jobs.DocumentStatus of "140" (Customer Review)
--		If @CR = 0, don't filter anything.
--		For report "Pending Jobs Per Clinic (Hourly Analysis).rdl"
-- =============================================
create PROCEDURE [dbo].[archive_sp_Reporting_PendingJobsPerClinic_Hourly] 

@CR INT

AS
BEGIN

	IF @CR = 0
		SET @CR = 120
	ELSE
		SET @CR = -999

	SELECT ClinicName,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11] FROM [Entrada].[dbo].Clinics 
		LEFT OUTER JOIN
			(SELECT ClinicID, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11] 
			FROM
				(SELECT Count(*) As NumJobs, ClinicID, NumCat 
				FROM
					(SELECT Jobs.JobNumber, 
					Jobs.ClinicID,
					CASE WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 360 THEN 1
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 360 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 720 THEN 2
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 720 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1080 THEN 3
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1080 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1440 THEN 4
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1440 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1680 THEN 5
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1680 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 1920 THEN 6
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 1920 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2160 THEN 7
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2160 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2400 THEN 8
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2400 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2640 THEN 9
						   WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2640 AND DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) <= 2880 THEN 10
						  WHEN DATEDIFF(minute, Jobs.ReceivedOn, GETDATE()) > 2880 THEN 11
					END AS NumCat
					FROM [Entrada].[dbo].Jobs 
					INNER JOIN [Entrada].[dbo].JobStatusA ON 
						Jobs.JobNumber=JobStatusA.JobNumber 
					WHERE JOBS.DocumentStatus != @CR 
						OR Jobs.DocumentStatus IS NULL) t
					GROUP BY ClinicID, NumCat) t1
				PIVOT (MAX(NumJobs) 
				FOR NumCat IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11])) pvt) C ON 
		Clinics.ClinicID=C.ClinicID
	WHERE Clinics.Active='True'
	ORDER BY ClinicName
	
END

GO
