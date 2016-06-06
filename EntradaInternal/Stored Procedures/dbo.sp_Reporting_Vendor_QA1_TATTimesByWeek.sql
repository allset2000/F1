SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



	
/* =======================================================
Author:			Dustin Dorsey
Create date:	8/22/14
Description:	Returns Total Vendor Editing TAT Times For last 12 Weeks By Week
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_Vendor_QA1_TATTimesByWeek]
	
	@VendorCompany varchar(500)

	AS

SELECT VendorName, WeekNumber, StartofWeek
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
      ,DATEPART(wk, J.CompletedOn) as WeekNumber
      ,CONVERT(varchar(50), (DATEADD(dd, @@DATEFIRST - DATEPART(dw, J.CompletedOn)-6, J.CompletedOn)), 101) as StartofWeek
      ,J.JobNumber
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
	J.CompletedOn > dateadd(week,-12,getdate())
	--J.CompletedOn > '01/01/2014'
	AND C.CompanyName in (select [Value] from dbo.split(@VendorCompany,','))
	--and C.companycode in ('Map','EHS','PRO','MTP','SCR','PTI','ENT')
	and JET.currentstateID = 501
	and JET.TaskStatus not in ('P', 'R')
	and J.STAT = 0 
	and J.CompletedOn is not null
 Group BY J.CompletedOn, JT.StatusDate, J.jobNumber, C.Companyname, DATEPART(wk, J.CompletedOn), CONVERT(varchar(50), (DATEADD(dd, @@DATEFIRST - DATEPART(dw, J.CompletedOn), J.CompletedOn)), 101)) A
 Group By VendorName, WeekNumber, StartofWeek
 Order by VendorName, WeekNumber






GO
