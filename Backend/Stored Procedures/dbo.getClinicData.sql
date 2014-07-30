SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getClinicData] (
   @ClinicID smallint
) AS
	SELECT ISNULL(Clinics.JobTag, '') AS JobTag, ISNULL(Clinics.PatientTag, '') AS PatientTag
	FROM   dbo.Clinics
    WHERE (ClinicID = @ClinicID)
RETURN
GO
