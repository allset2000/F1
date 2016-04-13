SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spGetClinic
--X
--X AUTHOR: Suresh
--X
--X DESCRIPTION: Get Clinic based on clinic ID
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 05-18-2015   | Suresh		  			| Initial design
--X   1    | 06-08-2015   | Sam Shoultz  			| 4355 - Added new Clinic values / variables to the SP
--X   2    | 04-07-2016   | Naga					| 6446 - Modified the proc to return "Express Link ApiKey" as part of the resultset
--X   3    | 04-12-2016   | Santhosh				| Chubbs Ticket
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
	C.RealTimeClinicIP,
	C.RealTimeClinicPortNo,
	C.RealTimeEnabled,
	EV.CanAck, 
	EV.Name AS EHRVendorName,
	CA.ConnectionString AS ApiConnectionString,
	EL.ApiKey,
	C.RhythmWorkFlowID,
	C.AppSetting_DisableSendToTranscription
	FROM Clinics C 
		INNER JOIN EHRVendors EV ON C.EHRVendorID = EV.EHRVendorID
		LEFT OUTER JOIN ClinicApis CA ON C.ClinicID = CA.ClinicID
		LEFT OUTER JOIN ExpressLinkConfigurations EL ON EL.ClinicID = C.ClinicID
	WHERE C.ClinicID = @vintClinicID
END  
GO
