-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to get all Row Clinics
CREATE PROCEDURE [dbo].[qryGetAllROWAdminClinics]
AS
BEGIN
	SELECT 
	ROW_AdminsClinics.PermissionId
	, ROW_AdminsClinics.Admin_ID
	, ROW_AdminsClinics.Clinic_ID
	, Clinics.ClinicName
	FROM ROW_AdminsClinics
	INNER JOIN Clinics ON Clinics.ClinicID = ROW_AdminsClinics.Clinic_ID
END
GO


