SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Jennifer Blumenthal
Create date:	5/10/13
Description:	Retrieves data for report "QA Production - All Jobs.rdl"

change log:

date		username		description
9/4/13		jablumenthal	changed filter from using EP2.PayType (original vendor)
							to using EP.PayType (task vendor) to more closely match
							the report that the ops folks are looking at in their
							reporting portal.  requested by Sue Fleming.
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_QAProduction_all] 
--declare
	@BeginDate DATETIME,
	@EndDate DATETIME, 
	@PayTypeVar varchar(max)

--set @BeginDate = '2013-05-13'
--set @EndDate = '2013-05-13'
--set @paytypevar = 'CEL, EHS, ENT, HTC, MAP, MTP, PRO, PTI'	--for testing

AS
BEGIN

select  case
			when isnull(EP2.PayType, '') = '' then 'UNK'
			else EP2.PayType
		end as OriginalVendor,
		E.LastName + ', ' + E.FirstName as QAName,
		J.JobNumber, 
		jcurr.StateName as JobState,
		EP.PayType as TaskVendor,
		tcurr.StateName as TaskName,
		JET.TaskStatus, 
		JET.ReceivedOn as taskReceivedOn, 
		JET.ReturnedOn as taskReturnedOn, 
		tnext.StateName as NextTaskName,
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
	 on JES.CurrentStateID = jcurr.WorkflowStateID
left outer join Entrada.dbo.Editors E with (nolock)
	 on JET.AssignedToID = E.EditorID				--task editor/QA person
left outer join Entrada.dbo.Editors_Pay EP with (nolock)
	 on E.EditorID = EP.EditorID					--task vendor
left outer join Entrada.dbo.JobEditingTasksData JETD with (nolock)
	 on JET.JobEditingTaskID = JETD.JobEditingTaskID
left outer join Entrada.dbo.Editors E2 with (nolock)
	 on J.EditorID = E2.EditorID					--original editor on the job
left outer join Entrada.dbo.Editors_Pay EP2 with (nolock)
	 on E2.EditorID = EP2.EditorID					--original vendor on the job
--where J.JobID in (617846, 144383, 1670098, 1670104, /*1667050, 1670976, 1670991,*/ 783063, 1700958)  --for testing
where convert(date, JET.ReceivedOn) between @BeginDate and @EndDate
  and case
		when isnull(EP.PayType, '') = '' then 'UNK'
		else EP.PayType
	  end in (select ltrim(id) from dbo.ParamParserFn(@PayTypeVar,','))
  and tcurr.EditionStage = 'QA'
  and JET.TaskStatus <> 'P'
order by J.JobNumber, JET.JobEditingTaskID


END
GO
