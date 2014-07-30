SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves editor production data
				for report "Jobs Dictated and Delivered Per Day (All Clinics).rdl"
				
change log

date		username		description
2/4/13		jablumenthal	added DictatorID per Jeff McNeese request
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_JobsDictatedAndEdited_PerDay_AllClinics]

	@BeginDate datetime, 
	@EndDate datetime,
	@PayTypeVar varchar(20) -- ClinicCode

AS
BEGIN

SET NOCOUNT ON

IF @PayTypeVar = 'QID'
	BEGIN

		SELECT  CONVERT(DATE, J.ReceivedOn, 101) AS StartDate, 
				CONVERT(DATE, J.ReceivedOn, 101) AS EndDate, 
				J.ClinicID, 
				C.ClinicName, 
				COUNT(DISTINCT(J.JobNumber)) as [Jobs Received],
				0 as [Jobs Returned],
				0 as [Lines]
		FROM Entrada.dbo.Jobs J
		JOIN Entrada.dbo.Clinics C ON 
			 J.ClinicID = C.ClinicID
		WHERE J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
		  AND C.ClinicID IN (8, 14, 22, 31, 32, 36, 41)
		GROUP BY CONVERT(DATE, J.ReceivedOn, 101),
			J.ClinicID, 
			C.ClinicName
			
		UNION ALL

		SELECT  CONVERT(DATE, J.CompletedOn, 101) AS StartDate, 
				CONVERT(DATE, J.CompletedOn, 101) AS EndDate, 
				J.ClinicID, 
				C.ClinicName,
				0 as [Jobs Received],
				COUNT(J.JobNumber) as [Jobs Returned],
				(CAST(BJ.NumVBC as DECIMAL(10, 2)) / 65) as [Lines]
				--(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65) as [Lines]
		FROM Entrada.dbo.Jobs J
		JOIN Entrada.dbo.Clinics C ON 
			 J.ClinicID = C.ClinicID
		JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
			 J.JobNumber = BJ.JobNumber
		--JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON
		--	 J.JobNumber = JED.JobNumber		
		WHERE (J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)) 
		  AND C.ClinicID IN (8, 14, 22, 31, 32, 36, 41)
		GROUP BY CONVERT(DATE, J.CompletedOn, 101), 
				 J.ClinicID, 
				 C.ClinicName,
				(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65)
		ORDER BY StartDate,
				 C.ClinicName	
	END

ELSE
	BEGIN
		SELECT  CONVERT(DATE, J.ReceivedOn, 101) AS StartDate, 
				CONVERT(DATE, J.ReceivedOn, 101) AS EndDate, 
				J.ClinicID, 
				C.ClinicName, 
				COUNT(DISTINCT(J.JobNumber)) as [Jobs Received],
				0 as [Jobs Returned],
				0 as [Lines]
		FROM [Entrada].[dbo].Jobs J
		JOIN [Entrada].[dbo].Clinics C ON 
			 J.ClinicID = C.ClinicID
		WHERE J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
		  --AND (C.ClinicCode = @PayTypeVar ) --commented out by jen so that this report will run for Bill (per Mike) jb 2/15/13
		GROUP BY CONVERT(DATE, J.ReceivedOn, 101),
				 J.ClinicID, 
				 C.ClinicName
			
		UNION ALL

		SELECT  CONVERT(DATE, J.CompletedOn, 101) AS StartDate, 
				CONVERT(DATE, J.CompletedOn, 101) AS EndDate, 
				J.ClinicID, 
				C.ClinicName,
				0 as [Jobs Received],
				COUNT(J.JobNumber) as [Jobs Returned],
				(CAST(BJ.NumVBC as DECIMAL(10, 2)) / 65) as [Lines]
				--(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65) as [Lines]
		FROM [Entrada].[dbo].Jobs J
		JOIN [Entrada].[dbo].Clinics C ON 
			 J.ClinicID = C.ClinicID
		JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
			 J.JobNumber = BJ.JobNumber
		--JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		--	 J.JobNumber = JED.JobNumber		
		WHERE (J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)) 
		  --AND (C.ClinicCode = @PayTypeVar ) --commented out by jen so that this report will run for Bill (per Mike) jb 2/15/13
		GROUP BY CONVERT(DATE, J.CompletedOn, 101), 
				 J.ClinicID, 
				 C.ClinicName,
				(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65)
		ORDER BY StartDate,
				 C.ClinicName	
	END

END
GO
