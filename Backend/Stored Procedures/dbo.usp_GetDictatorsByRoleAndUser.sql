SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_GetDictatorsByRoleAndUser] 
	@ClinicName varchar(50),
	@DictatorID varchar(50),
	@IsUserInRole varchar(50)
AS
BEGIN
	IF(@IsUserInRole = 'Super_Admin')
	BEGIN
		SELECT Dictators.DictatorID, Dictators.FirstName, Dictators.LastName 
		FROM Dictators INNER JOIN Clinics ON Dictators.ClinicID = Clinics.ClinicID  
		WHERE Clinics.ClinicName = @ClinicName  
		ORDER BY Dictators.LastName, Dictators.FirstName ASC
	END
	ELSE IF(@IsUserInRole = 'Clinic_Admin')
	BEGIN
		SELECT Dictators.DictatorID, Dictators.FirstName, Dictators.LastName 
		FROM Dictators INNER JOIN Clinics ON Dictators.ClinicID = Clinics.ClinicID  
		WHERE Clinics.ClinicName = @ClinicName  
		ORDER BY Dictators.LastName, Dictators.FirstName ASC
	END
	ELSE IF(@IsUserInRole = 'Physician')
	BEGIN
		SELECT Dictators.DictatorID, Dictators.FirstName, Dictators.LastName 
		FROM Dictators INNER JOIN Clinics ON Dictators.ClinicID = Clinics.ClinicID  
		WHERE Dictators.DictatorID = @DictatorID  
		ORDER BY Dictators.LastName, Dictators.FirstName ASC
	END		
END
GO
