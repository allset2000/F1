SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/24/2012
-- Description:	Creates notification if any 
--		Huron Valley jobs that we receive have 
--		a status-code of 150 (Failed Rec). 
--		For report "Failed Rec (Huron Valley).rdl"

-- Change Log:
-- date		username		description
-- 10/30/13	jablumenthal	added MRN per Ron Spears request
-- =============================================
CREATE PROCEDURE [dbo].[sp_Monitoring_RecFailed]

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @NumCount int
	
	SELECT @NumCount = COUNT(*)
	FROM [Entrada].[dbo].JobStatusA JSA WITH(NOLOCK)
	WHERE JSA.[Status] = 150
				
	IF @NumCount = 0
		BEGIN
			SELECT 1/0
		END
	ELSE
		BEGIN 
			SELECT C.ClinicName,
				D.LastName + ', ' + D.FirstName AS [Speaker],
				JSA.JobNumber,
				J.ReceivedOn,
				CASE J.STAT
					WHEN 1 THEN 'Y'
					ELSE 'N'
				END AS [Stat],
				JP.MRN
			FROM [Entrada].[dbo].JobStatusA JSA WITH(NOLOCK)
			INNER JOIN [Entrada].[dbo].Jobs J WITH(NOLOCK) ON
				JSA.JobNumber = J.JobNumber
			LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
				J.DictatorID = D.DictatorID
			LEFT OUTER JOIN [Entrada].[dbo].[Clinics] C WITH(NOLOCK) ON
				J.ClinicID = C.ClinicID
			JOIN Entrada.dbo.Jobs_Patients JP WITH (NOLOCK) ON
				J.JobNumber = JP.JobNumber
			WHERE JSA.[Status] = 150
		END
	
END	

GO
