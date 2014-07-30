SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/23/2012
-- Description:	Notifies On-Call editors of any 
--		Huron Valley jobs that we receive over 
--		the weekend. 
--		For report "Evening and Weekend Jobs Received (Huron Valley).rdl"

-- =============================================
CREATE PROCEDURE [dbo].[sp_Monitoring_OutstandingSTATJobs]

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @NumCount int
	

	BEGIN

		SELECT @NumCount = COUNT(*)
		FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK) 
		WHERE J.Stat = 1 AND
			J.ReturnedOn IS NULL AND
			J.CompletedOn IS NULL
		
		IF @NumCount = 0
			BEGIN
				SELECT 1/0
			END
		ELSE
			BEGIN 
				SELECT C.ClinicName,
					D.LastName + ', ' + D.FirstName AS [Speaker],
					J.JobNumber,
					J.ReceivedOn
				FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK) 
				INNER JOIN [Entrada].[dbo].[Dictators] D WITH(NOLOCK) ON
					J.DictatorID = D.DictatorID
				INNER JOIN [Entrada].[dbo].[Clinics] C WITH(NOLOCK) ON
					J.ClinicID = C.ClinicID
				WHERE J.Stat = 1 AND
					J.ReturnedOn IS NULL AND
					J.CompletedOn IS NULL
				ORDER BY ClinicName,
					Speaker,
					ReceivedOn
			END
	
	END	

END
GO
