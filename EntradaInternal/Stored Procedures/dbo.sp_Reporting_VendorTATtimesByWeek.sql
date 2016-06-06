SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_Reporting_VendorTATtimesByWeek]

@VendorCompany varchar(500),
@Stat smallint

AS

SELECT  VendorName, 
		WeekNumber, 
		StartofWeek, 
		TotalJobs, 
		TotalNOTStat, 
		InTAT, 
		OutOfTAT, 
		TotalStat, 
		STATInTAT, 
		STATOutOfTAT,
		CASE WHEN InTAT <> 0 THEN CAST((InTAT) as Float) / CAST((TotalNOTStat) as Float)ELSE 0 END as InTATPercent,
		CASE WHEN OutOfTAT <> 0 THEN CAST((OutOfTAT) as Float) / CAST((TotalNOTStat) as Float)ELSE 0 END as OutOfTATPercent,
		CASE WHEN STATInTAT <> 0 THEN CAST((STATInTAT) as Float) / CAST((TotalStat) as Float)ELSE 0 END as STATInTATPercent,
		CASE WHEN STATOutOfTAT <> 0 THEN CAST((STATOutOfTAT) as Float) / CAST((TotalStat) as Float)ELSE 0 END as STATOutOfTATPercent
	FROM (
		SELECT  V.CompanyName as VendorName,
			DATEPART(wk, J.CompletedOn) as WeekNumber,
			CONVERT(varchar(50), (DATEADD(dd, @@DATEFIRST - DATEPART(dw, J.CompletedOn)-6, J.CompletedOn)), 101) as StartofWeek,
			COUNT(J.JobNumber) as TotalJobs,
			COUNT(CASE WHEN J.STAT = 0 THEN 1 END) as TotalNOTStat,
			COUNT(CASE WHEN J.STAT = 0 AND DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) <= 1440 THEN 1 END) As InTAT,
			COUNT(CASE WHEN J.STAT = 0 AND DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) > 1440 THEN 1 END) As OutOfTAT,
			COUNT(CASE WHEN J.STAT = 1 THEN 1 END) as TotalStat,
			COUNT(CASE WHEN J.STAT = 1 AND DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) <= 120 THEN 1 END) As STATInTAT,
			COUNT(CASE WHEN J.STAT = 1 AND DATEDIFF(MI, J.ReceivedOn, JET.ReturnedOn) > 120 THEN 1 END) As STATOutOfTAT
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
 		INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON J.EditorID = E.EditorID
		INNER JOIN Entrada.dbo.Editors_Pay EP WITH (NOLOCK) ON E.EditorID = EP.EditorID
		INNER JOIN Entrada.dbo.DSGCompanies V WITH (NOLOCK) ON EP.PayType = V.CompanyCode
		--INNER JOIN Entrada.dbo.JobEditingTasks JET WITH (NOLOCK) ON JET.JobID = J.JobID
		INNER JOIN (SELECT MAX(ReturnedOn) as ReturnedOn, JobID FROM Entrada.dbo.JobEditingTasks (NOLOCK) WHERE CurrentStateID <= 504 GROUP BY JobID) AS JET ON JET.JobID = J.JobID
	WHERE 
		J.CompletedOn > dateadd(week,-12,getdate())
		AND V.CompanyName is not null
		--AND JET.CurrentStateID <= 504
		and J.CompletedOn is not null
		--AND V.CompanyCode in ('Map','EHS','PRO','MTP','SCR','PTI','ENT')
	    AND V.CompanyName in (select [Value] from dbo.split(@VendorCompany,',')) 
		GROUP BY V.CompanyName, DATEPART(wk, J.CompletedOn), CONVERT(varchar(50), (DATEADD(dd, @@DATEFIRST - DATEPART(dw, J.CompletedOn)-6, J.CompletedOn)), 101)
	) A
	ORDER BY Vendorname, WeekNumber

GO
