/******************************  
** File:  spGetClinic.sql  
** Name:  spGetClinic  
** Desc:  Get Clinic based on clinic ID 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetClinic] 
(  
 @vintClinicID  INT  
)  
AS  
BEGIN 
	SELECT C.ClinicID,
	 C.Name,
	 C.MobileCode,
	 C.AccountManagerID,
	 C.ExpressQueuesEnabled,
	 C.ImageCaptureEnabled,
	 C.PatientClinicalsEnabled,
	 C.Deleted,
	 C.EHRVendorID,
	 C.EHRClinicID,
	 C.EHRLocationID,
	 C.ClinicCode,
	 C.DisableUpdateAlert,
	 C.CRFlagType,
	 C.ForceCRStartDate,
	 C.ForceCREndDate,
	 C.ExcludeStat,
	 C.AutoEnrollDevices,
	 C.SRETypeId,
	 C.DisablePatientImages,
	 C.PortalTimeout,
	 C.DaysToResetPassword,
	 C.PreviousPasswordCount,
	 C.PasswordMinCharacters,
	 C.FailedPasswordLockoutCount,
	 C.TimeZoneId,
	EV.CanAck, 
	EV.Name AS EHRVendorName,
	CA.ConnectionString AS ApiConnectionString
	FROM Clinics C 
		INNER JOIN EHRVendors EV 
		ON C.EHRVendorID = EV.EHRVendorID
		LEFT OUTER JOIN ClinicApis CA
		ON C.ClinicID = CA.ClinicID
	WHERE C.ClinicID = @vintClinicID
END  
GO  






