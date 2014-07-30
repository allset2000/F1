SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time (Vanderbilt).rdl"
-- =============================================
Create PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_ClinicStandard]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(30)

AS
BEGIN

SET NOCOUNT ON

create table #clinic_hold (clinicID int)
insert into #clinic_hold values (@PayTypeVar)

SELECT C.ClinicName as [Clinic],
		J.JobType as [Job Type],
		J.EditorID as [Editor ID],
		J.JobNumber as [Job Number],
		J.ReceivedOn as [Received],
		J.CompletedOn as [Completed],
		J.DictatorID as [Dictator],
		DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
		COUNT(J2.JobNumber) AS OnTime,
		COUNT(J.JobNumber)  AS Total
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		J.JobNumber = J2.JobNumber
		AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
		AND J.ClinicID IN (select ClinicID from #clinic_hold)	
	GROUP BY C.ClinicName,
			J.JobType,
			J.EditorID,
			J.ReceivedOn,
			J.CompletedOn,
			J.DictatorID,
			J.JobNumber
	ORDER BY C.ClinicName,
		J.JobType,
		[OnTime]
		
		
END
GO
