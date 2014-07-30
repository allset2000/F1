SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves dictator production data
--		for report "Dictator Production - All Clinics (52 wk).rdl"
--
-- change log:
-- date		user			description
-- 3/27/13	jablumenthal	archived stored procedure as-is and made
--							changes to the replacement stored proc
--							per Cindy Gulley.
-- =============================================
CREATE PROCEDURE [dbo].[archive_sp_Reporting_DictatorProduction_52wk] 

AS
BEGIN

	DECLARE @Date datetime

	SET @Date = CONVERT(VARCHAR ,DATEADD(wk, -52, GetDate()), 110)

	SELECT C.ClinicName as ClinicName,
		DATEADD(wk, DATEDIFF(wk, 0, ReceivedOn), 0) as [Week Commencing],
		COUNT(JobNumber) AS NumJobs
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	WHERE ReceivedOn>=@Date
	GROUP BY C.ClinicName, DATEADD(wk, DATEDIFF(wk, 0, ReceivedOn), 0) 
	ORDER BY C.ClinicName, DATEADD(wk, DATEDIFF(wk, 0, ReceivedOn), 0) 
	
END

GO
