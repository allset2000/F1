SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves data for report "Jobs From Editors To QA.rdl"

change log:
date		username		description
4/30/13		jablumenthal	changed proc to use new QA workflow view
							the commented out part are the tables/columns
							that were in use in the prior QA workflow
================================================================= */

CREATE PROCEDURE [dbo].[sp_Reporting_JobsFromEditorsToQA_ByClinic]
--declare
	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN

--set @StartDate = '2013-05-21'
--set @EndDate = '2013-05-21'

	SELECT  C.ClinicName,
			J.DictatorID,
			J.JobType,
			E.LastName + ', ' + E.FirstName as EditorName,
			count(J.JobNumber) as Jobs,
			sum(case when JET.TaskStatus not in ('P', 'R') and v.EditionStage = 'QA' then 1 else 0 end) as QA_jobs,
			cast(cast(sum(case when JET.TaskStatus not in ('P', 'R') and v.EditionStage = 'QA' then 1 else 0 end) as decimal(12,5)) / cast(count(J.JobNumber) as decimal(12,5)) as decimal(12,5)) as QA_pct
	from Entrada.dbo.Jobs J with (nolock)
	join Entrada.dbo.Clinics C with (nolock)
		 on J.ClinicID = C.ClinicID
	join Entrada.dbo.Editors E with (nolock)
		 on J.EditorID = E.EditorID
	left outer join Entrada.dbo.JobEditingTasks JET with (nolock)
		 on J.JobID = JET.JobID
	join Entrada.dbo.vwWorkflowStates v 
		 on JET.CurrentStateID = v.WorkflowStateID
	where convert(date, J.ReceivedOn) between @StartDate and @EndDate
	group by C.ClinicName,J.DictatorID,J.JobType,E.LastName,E.FirstName
	order by C.ClinicName,J.DictatorID,J.JobType,E.LastName,E.FirstName
			

END

GO
