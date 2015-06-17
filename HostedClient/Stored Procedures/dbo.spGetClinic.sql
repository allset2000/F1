
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
** File:  spGetClinicById.sql
** Name:  spGetClinicById
** Desc:  Get SreTypeId of Clinic  based on clinic id
** Auth:  Suresh
** Date:  30/05/2015
**************************
** Change History
******************
** Ticket       Date	    Author           Description	
** --           --------    -------          ------------------------------------
** D.2 - 4355   6/8         Sam Shoultz      Added new Clinic values / variables to the SP
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
	C.RealTimeClinicIP,
	C.RealTimeClinicPortNo,
	C.RealTimeEnabled,
	EV.CanAck, 
	EV.Name AS EHRVendorName,
	CA.ConnectionString AS ApiConnectionString
	FROM Clinics C 
		INNER JOIN EHRVendors EV ON C.EHRVendorID = EV.EHRVendorID
		LEFT OUTER JOIN ClinicApis CA ON C.ClinicID = CA.ClinicID
	WHERE C.ClinicID = @vintClinicID
END  
GO
