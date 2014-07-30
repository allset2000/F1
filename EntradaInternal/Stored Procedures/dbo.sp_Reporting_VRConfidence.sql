SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	returns data for "VR Confidence Report.rdl"

change log:

date		username		description
6/11/13		jablumenthal	code was internal to report.  created
							procedure to replace internal code.
======================================================= */
create PROCEDURE [dbo].[sp_Reporting_VRConfidence]

	@StartTime1 datetime, 
	@StartTime2 datetime
	
AS
BEGIN

	SELECT  S.Dictator, 
			AVG(S.Confidence) AS Confidence, 
			COUNT(S.Job) AS NumJobs, 
			D.[Signature]
	FROM Entrada.dbo.[Stats] S with (nolock)
	LEFT OUTER JOIN Entrada.dbo.Dictators D with (nolock) 
		 ON S.Dictator = D.DictatorID
	WHERE (S.NumWords IS NOT NULL) 
	  AND (S.Confidence <> 0) 
	  AND (S.StartTime > @StartTime1) 
	  AND (S.StartTime < @StartTime2)
	GROUP BY S.Dictator, D.[Signature]
	--ORDER BY S.Confidence DESC


END
GO
