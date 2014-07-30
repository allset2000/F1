SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetClinicsByRoleAndUser]	
	@ClinicName varchar(50),
	@DictatorID varchar(50),
	@IsUserInRole varchar(50)
AS
BEGIN
	IF(@IsUserInRole = 'Clinic_Admin')
	BEGIN
		SELECT DISTINCT Clinics.ClinicName, Clinics.ClinicID
		FROM Clinics INNER JOIN Dictators ON Clinics.ClinicID = Dictators.ClinicID
		WHERE Clinics.ClinicName = @ClinicName  
		ORDER BY Clinics.ClinicName ASC
	END
	ELSE IF(@IsUserInRole = 'Physician')
	BEGIN
		SELECT DISTINCT Clinics.ClinicName, Clinics.ClinicID
		FROM Clinics INNER JOIN Dictators ON Clinics.ClinicID = Dictators.ClinicID
		WHERE Dictators.DictatorID = @DictatorID
		ORDER BY Clinics.ClinicName ASC
	END
	ELSE /*IF(@IsUserInRole = 'Super_Admin')*/
	BEGIN
		SELECT DISTINCT Clinics.ClinicName, Clinics.ClinicID
		FROM Clinics INNER JOIN Dictators ON Clinics.ClinicID = Dictators.ClinicID
		ORDER BY Clinics.ClinicName ASC
	END
END

GO
