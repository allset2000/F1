SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 7/29/15
-- Description: Temp SP used to allow support to clean our Athena jobs that are stuck in J2D due to the split job issue
-- =============================================

CREATE PROCEDURE [dbo].[sp_TFS749_FixStuckAthenaJobsInJTD] 

AS 

BEGIN
	
	UPDATE JD
	SET Method = 200
    FROM Entrada.dbo.JobsToDeliver JD 
	INNER JOIN Entrada.dbo.Jobs J ON JD.jobnumber = J.Jobnumber
	INNER JOIN EntradaHostedClient.dbo.Clinics C ON J.ClinicID=C.ClinicID
	LEFT JOIN Entrada.dbo.Jobs_client JC ON JD.jobnumber=JC.jobnumber
	WHERE Method = 900 AND JC.jobnumber IS NULL AND EHRVendorID = 2
	
END

GO
