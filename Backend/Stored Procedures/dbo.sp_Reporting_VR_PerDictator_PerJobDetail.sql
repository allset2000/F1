SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	returns data for "VR - Per Dictator Per Job Detail.rdl"

change log:

date		username		description
4/11/13		jablumenthal	code was internal to report.  created
							procedure to replace internal code 
							then archived procedure to replace it with
							a new one that uses the new QA workflow tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_VR_PerDictator_PerJobDetail]

	@StartTime1 datetime, 
	@StartTime2 datetime
	
AS
BEGIN

	SELECT  S.Dictator AS DictatorID, 
			C.ClinicName, 
			J.EditorID,
			(CAST(EJ.NumChars AS DECIMAL(10, 2)) / 65) as Lines,
			--(CAST(JED.NumChars_Editor AS DECIMAL(10, 2)) / 65) as [Lines],
			CAST(S.Confidence AS DECIMAL(10,2))/10 AS Confidence, 
			S.Job AS JobNumber,
			S.StartTime AS TimeReceived
	FROM Entrada.dbo.[Stats] S WITH(NOLOCK) 
	JOIN Entrada.dbo.Dictators D WITH(NOLOCK) ON 
		 S.Dictator = D.DictatorID 
	JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON 
		 D.ClinicID = C.ClinicID
	JOIN Entrada.dbo.Jobs J WITH(NOLOCK) ON
		 S.Job = J.JobNumber
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
	--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
	--	 J.JobNumber = JED.JobNumber
	WHERE (S.NumWords IS NOT NULL) 
	  AND Confidence <> 0 
	  AND StartTime > @StartTime1 
	  AND StartTime < @StartTime2 
	  AND Active = 1
	ORDER BY Dictator


END
                         
GO
