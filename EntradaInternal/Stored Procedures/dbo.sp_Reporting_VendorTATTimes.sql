SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Dustin Dorsey
Create date:	8/15/14
Description:	Returns Total Vendor TAT Times For last 12 months
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_VendorTATTimes]
	
	@MonthYear varchar(255),
	@VendorCompany varchar(500),
	@STAT smallint 
	
	AS
	
	SELECT 
		VendorName, 
		MonthYear, 
		TotalJobs, 
		TotalNONSTATJobs,
		InTAT,
		OutOfTAT,
		TotalSTATJobs,
		STATInTAT,
		STATOutOfTAT,
		SortDate,
		CASE WHEN InTAT <> 0 THEN CAST((InTAT) as Float) / CAST((TotalNONSTATJobs) as Float)ELSE 0 END as InTATPercent,
		CASE WHEN OutOfTAT <> 0 THEN CAST((OutOfTAT) as Float) / CAST((TotalNONSTATJobs) as Float)ELSE 0 END as OutOfTATPercent,
		CASE WHEN STATInTAT <> 0 THEN CAST((STATInTAT) as Float) / CAST((TotalSTATJobs) as Float)ELSE 0 END as STATInTATPercent,
		CASE WHEN STATOutOfTAT <> 0 THEN CAST((STATOutOfTAT) as Float) / CAST((TotalSTATJobs) as Float)ELSE 0 END as STATOutOfTATPercent
	FROM
	(
	SELECT  V.CompanyName as VendorName,
			CONVERT(varchar(50), DATENAME(m, J.CompletedOn) + ' ' + DATENAME(yyyy, J.CompletedOn)) as MonthYear,
			COUNT(J.JobNumber) as TotalJobs,
			COUNT(CASE WHEN J.STAT = 0 THEN 1 END) as TotalNONSTATJobs,
			COUNT(CASE WHEN J.STAT = 0 and DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) <= 1440 THEN 1 END) As InTAT,
			COUNT(CASE WHEN J.STAT = 0 and DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) > 1440 THEN 1 END) As OutOfTAT,
			COUNT(CASE WHEN J.STAT = 1 THEN 1 END) as TotalSTATJobs,
			COUNT(CASE WHEN J.STAT = 1 and DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) <= 120 THEN 1 END) As STATInTAT,
			COUNT(CASE WHEN J.STAT = 1 and DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) > 120 THEN 1 END) As STATOutOfTAT,
			MAX(J.CompletedOn) as SortDate
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
 		INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON J.EditorID = E.EditorID
		INNER JOIN Entrada.dbo.Editors_Pay EP WITH (NOLOCK) ON E.EditorID = EP.EditorID
		INNER JOIN Entrada.dbo.DSGCompanies V WITH (NOLOCK) ON EP.PayType = V.CompanyCode
		--INNER JOIN Entrada.dbo.JobEditingTasks JET WITH (NOLOCK) ON JET.JobID = J.JobID
		INNER JOIN (SELECT MAX(ReturnedOn) as ReturnedOn, JobID FROM Entrada.dbo.JobEditingTasks (NOLOCK) WHERE CurrentStateID <= 504 GROUP BY JobID) AS JET ON JET.JobID = J.JobID
	WHERE 
		J.CompletedOn BETWEEN Dateadd(Month, Datediff(Month, 0, DATEADD(m, -12, current_timestamp)), 0) and GetDate()
		AND CONVERT(varchar(50), DATENAME(m, J.CompletedOn) + ' ' + DATENAME(yyyy, J.CompletedOn)) IN (select [Value] from dbo.split(@MonthYear,',')) 
		AND V.CompanyName is not null
		AND V.CompanyName in (select [Value] from dbo.split(@VendorCompany,',')) 
		--AND V.CompanyCode in ('Map','EHS','PRO','MTP','SCR','PTI','ENT')
		--AND JET.CurrentStateID <= 504
		and J.CompletedOn is not null
	GROUP BY CONVERT(varchar(50), DATENAME(m, J.CompletedOn) + ' ' + DATENAME(yyyy, J.CompletedOn)),V.CompanyName
	) A
	ORDER BY VendorName, SortDate



GO
