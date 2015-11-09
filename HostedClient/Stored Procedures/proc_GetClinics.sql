USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetClinics]    Script Date: 8/17/2015 11:18:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
CREATE PROCEDURE [dbo].[proc_GetClinics] 
 
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
	CA.ConnectionString AS ApiConnectionString
	FROM Clinics C 
		INNER JOIN EHRVendors EV ON C.EHRVendorID = EV.EHRVendorID
		LEFT OUTER JOIN ClinicApis CA ON C.ClinicID = CA.ClinicID
	
END  
