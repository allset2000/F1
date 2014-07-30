SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves editor production data
--		for report "Editor Production - All Clinics (52 wk).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_52wk] 

AS
BEGIN

	DECLARE @Date datetime

	SET @Date = CONVERT(VARCHAR ,DATEADD(wk, -52, GetDate()), 110)

	SELECT C.ClinicName as ClinicName,
		DATEADD(wk, DATEDIFF(wk, 0, ReturnedOn), 0) as [Week Commencing],
		COUNT(JobNumber) AS NumJobs
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	WHERE ReturnedOn>=@Date
	GROUP BY C.ClinicName, DATEADD(wk, DATEDIFF(wk, 0, ReturnedOn), 0)
	ORDER BY C.ClinicName, DATEADD(wk, DATEDIFF(wk, 0, ReturnedOn), 0)
	
END

GO
