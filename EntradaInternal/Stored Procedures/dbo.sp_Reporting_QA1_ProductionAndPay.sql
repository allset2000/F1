SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	5/15/13
Description:	Retrieves QA1 production data
				for report "QA1 Production and Pay Report.rdl"
				
change log

date		username		description
5/15/13		jablumenthal	converted internal report code to 
							a stored proc and replaced tables
							to use new QA workflow.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_QA1_ProductionAndPay]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(25) 

AS
BEGIN

	Select  J.JobNumber,
			JET.AssignedToID, 
			JET.CurrentStateID, 
			convert(date, JET.ReturnedOn) as ReturnedOn, 
			JET.TaskStatus,
			v.StateName, 
			v.EditionStage,
			E.LastName + ', ' + E.FirstName as QAName,
			EP.PayType,
			JETD.NumChars as NumVBC, 
			JETD.NumVBC as NumChars,
			(JETD.NumVBC / 65.0) as Char_Lines,
			(JETD.NumChars / 65.0) as VBC_Lines
	from Entrada.dbo.Jobs J with (nolock)
	left outer join Entrada.dbo.JobEditingTasks JET with (nolock)
		 on J.JobID = JET.JobID
	left outer join Entrada.dbo.vwWorkflowStates v 
		 on JET.CurrentStateID = v.WorkflowStateID
	left outer join Entrada.dbo.Editors E with (nolock)
		 on JET.AssignedToID = E.EditorID
	left outer join Entrada.dbo.Editors_Pay EP with (nolock)
		 on E.EditorID = EP.EditorID
	left outer join Entrada.dbo.JobEditingTasksData JETD with (nolock)
		 on JET.JobEditingTaskID = JETD.JobEditingTaskID
	where convert(date, JET.ReturnedOn) between @ReceivedOn and @ReceivedOn2
	  and EP.PayType = @PayTypeVar
	  and v.StateName = 'QA1'
	  and JET.TaskStatus in ('C', 'F')

END
GO
