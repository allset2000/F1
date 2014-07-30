SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/8/2012
-- Description:	Retrieves data for report 
--		"Invoice - Vanderbilt.rdl"
-- =============================================
create PROCEDURE [dbo].[archive_sp_Reporting_InvoiceVanderbilt]
	@BeginDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
	
	
SELECT	C.ClinicName AS [Clinic], 
			J.DictatorID,
			J.JobNumber,
			J.Jobtype,
			JC.Custom1 as location, 
			CASE WHEN J.Stat = 0 THEN COALESCE(CAST(JED2.[DocumentWSpaces_Job] AS DECIMAL(10,2)), 0) / 65.0 ELSE 0 END AS [Normal Units],
			DT.decDocTechRate + DT.decDocEditRate AS [Normal Unit Rate],
			CASE WHEN J.Stat = 0 THEN COALESCE(CAST(JED2.[DocumentWSpaces_Job] AS DECIMAL(10,2)), 0) / 65.0 ELSE 0 END * (DT.decDocTechRate + DT.decDocEditRate) AS [Normal Amt],
			CASE WHEN J.Stat = 1 THEN COALESCE(CAST(JED2.[DocumentWSpaces_Job] AS DECIMAL(10,2)), 0) / 65.0 ELSE 0 END AS [Urgent Units],
			DT.decDocTechRate + DT.decDocEditRate + COALESCE(DT.decDocStatSurcharge, 0) AS [Urgent Unit Rate],
			CASE WHEN J.Stat = 1 THEN COALESCE(CAST(JED2.[DocumentWSpaces_Job] AS DECIMAL(10,2)), 0) / 65.0 ELSE 0 END * (DT.decDocTechRate + DT.decDocEditRate + COALESCE(DT.decDocStatSurcharge, 0)) AS [Urgent Amt],			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			CASE WHEN J.Stat = 1 Then 2.000 ELSE dt.tintdoctat END as [MaxTAT],
			CASE WHEN J.Stat = 1 Then 0.030 ELSE dt.decdocpenaltyamt END as [TATCharge]
	FROM [Entrada].[dbo].Clinics C WITH(NOLOCK)
		INNER JOIN [Entrada].[dbo].Jobs J WITH(NOLOCK) ON 
			c.ClinicID = J.ClinicID 
		INNER JOIN Entrada.dbo.Dictators D WITH(NOLOCK) ON
			J.DictatorID = D.DictatorID
		INNER JOIN [Entrada].[dbo].Jobs_EditingData2 JED2 WITH(NOLOCK) ON
			J.JobNumber = JED2.JobNumber 	
		INNER JOIN Document_TAT DT WITH(NOLOCK) ON
			J.ClinicID = DT.intClinicID AND
			J.JobType = DT.sDocType
		LEFT JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON
			J.Jobnumber=JC.Jobnumber 
		--LEFT JOIN vanderbiltMaxTAT VM WITH(NOLOCK) on 
		--	J.JobType = VM.JobType
	WHERE J.ClinicID in ('54')  and J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	
		
END

GO
