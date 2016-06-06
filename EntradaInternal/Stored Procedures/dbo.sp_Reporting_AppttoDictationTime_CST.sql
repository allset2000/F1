SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Sindhuri Manne
Create date:	11/13/14
Description:	Implementation report shows jobs Appt to Dictation Time
======================================================= */
	
	Create PROCEDURE [dbo].[sp_Reporting_AppttoDictationTime_CST] 
	@Clinic int,
	@Begin Datetime,
	@End Datetime
	
	AS

SELECT        j.DictatorID, j.JobNumber, j.AppointmentDate, j.AppointmentTime, j.ReceivedOn, j.ClinicID, c.ClinicName
FROM            Entrada.dbo.Jobs AS j INNER JOIN
                         Entrada.dbo.Clinics AS c ON j.ClinicID = c.ClinicID
WHERE        (j.ClinicID = @Clinic) AND (j.AppointmentDate BETWEEN @Begin AND @End)
ORDER BY j.DictatorID, j.AppointmentDate



GO
