SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	11/13/13
Description:	Retrieves turnaround summary data
				for report "Vanderbilt Orthopedic Clinic (VOI) Job Data.rdl"

change log:
date		username		description
11/13/13	jablumenthal	created proc
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_VanderbiltOrthopedicClinic_VOI_JobData]
--declare 
	@ReceivedOn DATETIME,	--start date
	@ReceivedOn2 DATETIME	--end date
	--,@PayTypeVar varchar(20)	--clinicID

--set @ReceivedOn = '11/11/13'
--set @ReceivedOn2 = '11/12/13'

AS
BEGIN

SET NOCOUNT ON

	SELECT  C.ClinicName as [Clinic],
			J.DictatorID,
			convert(date, J.ReceivedOn) as [Received],
			convert(date, J.CompletedOn) as [Completed],
			J.JobType,	
			convert(date, J.AppointmentDate) as ApptDate,	
			JP.MRN,
			J.JobNumber as [JobNumber],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TATmins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAThrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as EntradaLines,
			SUM(BJ.DocumentWSpaces / 65.0) as Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN Entrada.dbo.Jobs_Patients JP WITH (NOLOCK)
		 on J.JobNumber = JP.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		J.JobNumber = J2.JobNumber
		AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	--WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	WHERE convert(date, J.CompletedOn) between @ReceivedOn and @ReceivedOn2
	  and J.ClinicID = 54 --@PayTypeVar
	  and J.JobType in ('Clinic Note', 'Letter')
	GROUP BY C.ClinicName,
			 J.DictatorID,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobType,
			 J.AppointmentDate,
			 JP.MRN,
			 J.JobNumber
	ORDER BY [OnTime],
			 C.ClinicName

		
END
GO
