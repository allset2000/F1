SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* ==============================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves data for report "QA Production.rdl"

change log:
date		username		description
4/30/13		jablumenthal	changed proc to use new QA workflow view
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_JobsFromEditorsToQA]
--declare
	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN

--set @StartDate = '2013-05-21'
--set @EndDate = '2013-05-21'

	set concat_null_yields_null off

	select  EP.PayType,
			J.EditorID,
			E.LastName + ', ' + E.FirstName as EditorName,
			J.DictatorID,
			count(distinct J.JobNumber) as Jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.EditionStage = 'QA' then 1 else 0 end) as QA_jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA1' then 1 else 0 end) as QA1_jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA2' then 1 else 0 end) as QA2_jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA3' then 1 else 0 end) as QA3_jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA4' then 1 else 0 end) as QA4_jobs,
			cast((cast(sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA1' then 1 else 0 end) as decimal(12,5)) / cast(count(distinct J.JobNumber) as decimal(12,5))) as decimal(12,5)) as QA1_pct, 
			cast((cast(sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA2' then 1 else 0 end) as decimal(12,5)) / cast(count(distinct J.JobNumber) as decimal(12,5))) as decimal(12,5)) as QA2_pct, 
			cast((cast(sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA3' then 1 else 0 end) as decimal(12,5)) / cast(count(distinct J.JobNumber) as decimal(12,5))) as decimal(12,5)) as QA3_pct, 
			cast((cast(sum(case when JET.TaskStatus not in ('P', 'R') and v.QAStage = 'QA4' then 1 else 0 end) as decimal(12,5)) / cast(count(distinct J.JobNumber) as decimal(12,5))) as decimal(12,5)) as QA4_pct 
	from Entrada.dbo.Jobs J with (nolock)
	join Entrada.dbo.Editors E with (nolock)
		 on J.EditorID = E.EditorID
	left outer join Entrada.dbo.Editors_Pay EP with (nolock)
		 on E.EditorID = EP.EditorID
	left outer join Entrada.dbo.JobEditingTasks JET with (nolock)
		 on J.JobID = JET.JobID
	join Entrada.dbo.vwWorkflowStates v 
		 on JET.CurrentStateID = v.WorkflowStateID	--current state
	where convert(date, J.ReceivedOn) between @StartDate and @EndDate
	group by EP.PayType, J.EditorID, E.LastName + ', ' + E.FirstName, J.DictatorID


END
GO
