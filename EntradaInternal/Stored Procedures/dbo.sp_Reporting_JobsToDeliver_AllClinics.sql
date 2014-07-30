SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Jobs to Deliver - All Clinics.rdl"
				
change log

date		username		description
6/10/13		jablumenthal	replaced the internal code in the 
							report with this new stored proc
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_JobsToDeliver_AllClinics]

AS
BEGIN


	SELECT  vw.ClinicName, 
			vw.JobNumber, 
			vw.Method, 
			vw.RuleName, 
			vw.DictatorID, 
			vw.AppointmentDate, 
			vw.AppointmentTime, 
			vw.JobType, 
			vw.MRN, 
			vw.FirstName, 
			vw.LastName, 
			vw.DOB
	FROM Entrada.dbo.qryJobsToDeliver AS vw 
	JOIN Entrada.dbo.Clinics c with (nolock) 
		 ON vw.ClinicName = c.ClinicName
	WHERE (c.Active = 1)
	GROUP BY vw.ClinicName, 
			 vw.JobNumber, 
			 vw.Method, 
			 vw.RuleName, 
			 vw.DictatorID, 
			 vw.AppointmentDate, 
			 vw.AppointmentTime, 
			 vw.JobType, 
			 vw.MRN, 
			 vw.FirstName, 
			 vw.LastName, 
			 vw.DOB
	ORDER BY vw.ClinicName

END
GO
