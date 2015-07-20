SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 7/20/2015
-- Description: SP used to pull a the generic patient for a given clinicid
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClinicGenericPatient] (
	 @ClinicId int
) AS 
BEGIN
	SELECT P.*
	FROM SystemSettings SS
		INNER JOIN Patients P on P.PatientId = SS.GenericPatientID
	WHERE SS.ClinicId = @ClinicId		
END


GO
