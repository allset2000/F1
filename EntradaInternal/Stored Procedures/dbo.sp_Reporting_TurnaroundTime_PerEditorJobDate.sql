SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	5/8/13
Description:	Retrieves editor production data
				for report "Per Editor-Job-Date TAT Report.rdl"
				
change log

date		username		description
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_PerEditorJobDate]
--declare
	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	--@Stat varchar(5),
	@PayTypeVar varchar(100)
	
	--set @ReceivedOn = '2013-05-01'
	--set @ReceivedOn2 = '2013-05-06'
	--Set @Stat = 1
	--set @PayTypeVar = 'ENT'
	

AS
BEGIN

	--define parameters
	--if @Stat = 2
	--	begin
	--		set @Stat = '1, 0' --if user picked 'show all jobs' then we need to see both stat values
	--	end		
		

	SET NOCOUNT ON

	--get data
	SELECT  EP.PayType,
			E.LastName + ', ' + E.FirstName as EditorName,
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as Lines
			--SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	JOIN [Entrada].[dbo].Editors E WITH (NOLOCK) ON
		 J.EditorID = E.EditorID
	JOIN [Entrada].[dbo].Editors_Pay EP WITH (NOLOCK) ON
		 E.EditorID = EP.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
	  --and J.Stat in (select ltrim(id) from dbo.ParamParserFn(@stat, ','))
	  and EP.PayType = @PayTypeVar
	GROUP BY EP.PayType,
			 E.LastName + ', ' + E.FirstName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY EP.PayType,
			 E.LastName + ', ' + E.FirstName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
		
END

GO
