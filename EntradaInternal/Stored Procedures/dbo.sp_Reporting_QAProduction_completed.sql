SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Jennifer Blumenthal
Create date:	5/13/13
Description:	Retrieves data for report "QA Production - Completed Jobs.rdl"

change log:
date		username		description
5/29/13		jablumenthal	per Mike Cardwell parameters MUST be named
							@ReceivedOn, @ReceivedOn2, @PayTypeVar in client
							reports so that they will run in the portal. 
							Renamed my parameters as such.  Also, @PayTypeVar
							must be ClinicID (not ClinicCode as I had it) so I 
							fixed that as well. 
9/3/13		jablumenthal	changed the filter from "EP.PayType = @PayTypeVar"
							to "EP2.PayType = @PayTypeVar" so that this report
							matches QA Production - All Jobs.
9/4/13		jablumenthal	changed the filter back to EP.PayType to match 
							QA Production - All Jobs as requested by Sue Fleming
							so that this report also matches her reporting portal.
							Made the same change to QA Production - all jobs report.
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_QAProduction_completed] 
--declare
	@ReceivedOn DATETIME,
	@ReceivedOn2 DATETIME, 
	@PayTypeVar varchar(100)

--set @BeginDate = '2013-05-13'
--set @EndDate = '2013-05-13'
--set @paytypevar = 'CEL, EHS, ENT, HTC, MAP, MTP, PRO, PTI'	--for testing

AS
BEGIN

select  EP.PayType as TaskVendor,
		--case
--			when isnull(EP2.PayType, '') = '' then 'UNK'
--			else EP2.PayType
--		end as OriginalVendor,
		tcurr.StateName as TaskName,
		E.LastName + ', ' + E.FirstName as QAName,
		J.JobNumber, 
		--jcurr.StateName as JobState,
		--JET.TaskStatus, 
		JET.ReceivedOn as taskReceivedOn, 
		JET.ReturnedOn as taskReturnedOn, 
		--tnext.StateName as NextTaskName,
		--J.JobID, 
		--J.DictatorID, 
		--J.ClinicID, 
		--J.EditorID, 
		--J.Stat, 
		--J.ReceivedOn as jobReceivedOn, 
		--J.ReturnedOn as jobReturnedOn, 
		--J.CompletedOn as jobCompletedOn, 
		--J.JobEditingSummaryId,
		--JET.JobEditingTaskID, 
		--JET.AssignedToID, 
		--JET.AssignedOn as TaskCreatedOn, 
		--JES.QAEditorsList, 
		coalesce(JETD.NumChars, 0) as NumVBC, 
		coalesce(JETD.NumVBC, 0) as NumChars, 
		case
			when isnull(JETD.NumVBC, 0) = 0 then 0
			else JETD.NumVBC/65.0 
		end as Lines
from Entrada.dbo.Jobs J with (nolock)
left outer join Entrada.dbo.JobEditingTasks JET with (nolock)
	 on J.JobID = JET.JobID
left outer join Entrada.dbo.vwWorkflowStates tcurr
	 on JET.CurrentStateID = tcurr.WorkflowStateID  --current state of the task
left outer join Entrada.dbo.vwWorkflowStates tnext
	 on JET.NextStateID = tnext.WorkflowStateID		--next state of the task
left outer join Entrada.dbo.JobEditingSummary JES with (nolock)
	 on J.JobEditingSummaryID = JES.JobID
left outer join Entrada.dbo.vwWorkflowStates jcurr with (nolock)
	 on JES.CurrentStateID = jcurr.WorkflowStateID	--current state of the job
left outer join Entrada.dbo.Editors E with (nolock)
	 on JET.AssignedToID = E.EditorID				--task editor/QA person
left outer join Entrada.dbo.Editors_Pay EP with (nolock)
	 on E.EditorID = EP.EditorID					--task vendor
left outer join Entrada.dbo.DSGCompanies DC with (nolock)
	 on EP.PayType = DC.CompanyCode
left outer join Entrada.dbo.JobEditingTasksData JETD with (nolock)
	 on JET.JobEditingTaskID = JETD.JobEditingTaskID
left outer join Entrada.dbo.Editors E2 with (nolock)
	 on J.EditorID = E2.EditorID					--original editor on the job
left outer join Entrada.dbo.Editors_Pay EP2 with (nolock)
	 on E2.EditorID = EP2.EditorID					--original vendor on the job
--where J.JobID in (617846, 144383, 1670098, 1670104, /*1667050, 1670976, 1670991,*/ 783063, 1700958)  --for testing
where convert(date, JET.ReceivedOn) between @ReceivedOn and @ReceivedOn2
  and EP.PayType = @PayTypeVar  
  --and DC.CompanyID = @PayTypeVar
  and tcurr.EditionStage = 'QA'
  --and JET.TaskStatus not in ('P', 'R')
  and JET.TaskStatus in ('C', 'F')
order by EP.PayType, tcurr.StateName, E.LastName + ', ' + E.FirstName, J.JobNumber


END


GO
