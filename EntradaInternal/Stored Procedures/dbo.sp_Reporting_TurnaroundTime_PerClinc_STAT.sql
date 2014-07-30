SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	5/14/13
Description:	Retrieves editor production data
				for report "Turnaround Time per Clinic - STAT Jobs.rdl"
				
change log

date		username		description
7/26/13		jablumenthal	changed the on-time calculation
							to 2 hours per Cindy Gulley
8/13/13		jablumenthal	changed comments above
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_PerClinc_STAT]
	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(100)


AS
BEGIN

	SET NOCOUNT ON

	SELECT  --EP.PayType,
			--E.LastName + ', ' + E.FirstName as EditorName,
			C.ClinicName,
			J.JobNumber,
			J.ReceivedOn,
			J.CompletedOn,
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as TATmins,
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as TAThrs,
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as Lines
			--SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Clinics C WITH (NOLOCK) ON
		 J.ClinicID = C.ClinicID
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	JOIN [Entrada].[dbo].Editors E WITH (NOLOCK) ON
		 J.EditorID = E.EditorID
	JOIN [Entrada].[dbo].Editors_Pay EP WITH (NOLOCK) ON
		 E.EditorID = EP.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) <= 2)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
	  and J.Stat = 1
	  --and J.ClinicID = @PayTypeVar  --use this if we need @PayTypeVar to be a numeric
	  and C.ClinicCode = @PayTypeVar
	GROUP BY C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
		
END

GO
