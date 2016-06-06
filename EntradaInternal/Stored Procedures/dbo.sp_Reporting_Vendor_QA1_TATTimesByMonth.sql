SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Dustin Dorsey
Create date:	8/22/14
Description:	Returns Total Vendor QA1 TAT Times 
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_Vendor_QA1_TATTimesByMonth]
	
	@MonthYear varchar(255),
	@VendorCompany varchar(500)

	AS

SELECT
VendorName, MonthYear
      ,COUNT(CASE WHEN TimeDifference <= 960 THEN 1 END) As InTAT
      ,COUNT(CASE WHEN TimeDifference > 960 THEN 1 END) As OutofTAT
      ,(CAST(COUNT(CASE WHEN TimeDifference <= 960 THEN 1 END)as Float) / CAST(COUNT(JobNumber) as Float))  AS InTATPercent
      ,(CAST(COUNT(CASE WHEN TimeDifference > 960 THEN 1 END)as Float) / CAST(COUNT(JobNumber) as Float))  AS OutOfTATPercent
      ,COUNT(JobNumber) as TotalJobs
      ,MAX(CompletedOn) as SortDate
      FROM
      (
SELECT 
      C.Companyname as VendorName
      ,CONVERT(varchar(50), DATENAME(m, J.CompletedOn) + ' ' + DATENAME(yyyy, J.CompletedOn)) as MonthYear
      ,J.Jobnumber
      ,DATEDIFF(MI,JT.StatusDate, MAX(JET.ReturnedOn)) AS TimeDifference
      ,J.CompletedOn
 FROM Entrada.dbo.JobEditingTasks JET (nolock)
	Inner Join Entrada.dbo.Jobs J (nolock) On JET.JobID = J.JobID
	INNER JOIN Entrada.dbo.vwWorkflowStates v (nolock) on JET.CurrentStateID = v.WorkflowStateID	
	INNER JOIN Entrada.dbo.vwWorkflowStates v2 (nolock) on JET.NextStateID = v2.WorkflowStateID	
	INNER join Entrada.dbo.Editors E (nolock) on JET.AssignedToID = E.EditorID
	INNER join Entrada.dbo.Editors_Pay EP (nolock) on E.EditorID = EP.EditorID
	INNER JOIN Entrada.dbo.DSGCompanies C (nolock)  ON EP.PayType = C.CompanyCode
	INNER JOIN (SELECT MIN(StatusDate) as StatusDate, JobNumber FROM Entrada.dbo.JobTracking (nolock) WHERE Status = 140 Group BY Jobnumber) JT ON JT.JobNumber = J.JobNumber 
 WHERE 
	JT.StatusDate BETWEEN Dateadd(Month, Datediff(Month, 0, DATEADD(m, -12, current_timestamp)), 0) and GetDate()
   AND CONVERT(varchar(50), DATENAME(m, JT.StatusDate) + ' ' + DATENAME(yyyy, JT.StatusDate)) IN (select [Value] from dbo.split(@MonthYear,','))
	AND C.CompanyName in (select [Value] from dbo.split(@VendorCompany,','))
	--and C.companycode in ('Map','EHS','PRO','MTP','SCR','PTI','ENT')
	--and J.CompletedOn > '01/01/2014'
	and JET.currentstateID = 501
	and JET.TaskStatus not in ('P', 'R')
	and J.STAT = 0 
	and J.CompletedON is not null
 Group BY J.CompletedOn, J.Jobnumber, JT.StatusDate, C.Companyname, CONVERT(varchar(50), DATENAME(m, J.CompletedOn) + ' ' + DATENAME(yyyy, J.CompletedOn))) A
 GROUP BY VendorName, MonthYear
 Order by VendorName, MAX(CompletedOn)


GO
