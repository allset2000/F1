SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 4/29/2015
-- Description: SP called from DictateAPI to pull patients data
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientById] (
	 @PatientId int
) AS 
BEGIN
	SELECT PatientId,
		   ClinicId,
		   MRN,
		   AlternateId,
		   FirstName,
		   MI,
		   LastName,
		   Suffix,
		   Gender,
		   Address1,
		   Address2,
		   City,
		   State,
		   Zip,
		   CASE WHEN ISDATE(dob) = 1 THEN convert(varchar(10),cast(dob as date),101) ELSE '01/01/1900' END as 'DOB',
		   Phone1,
		   Phone2,
		   Fax1,
		   Fax2,
		   PrimaryCareProviderId
	FROM Patients
	Where PatientId = @PatientId
END
GO
