SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Sindhuri Manne
Create date:	11/25/14
Description:	Implementation report shows jobs Appt to Dictation Time for Eastern Time
======================================================= */
	
	Create PROCEDURE [dbo].[sp_Reporting_AppttoDictationTime_EST]
	@Clinic int,
	@Begin Datetime,
	@End Datetime
	
	AS

SELECT       j.DictatorID, j.JobNumber, j.AppointmentDate, j.AppointmentTime, j.ReceivedOn, j.ClinicID, c.CLinicName
FROM            Entrada.dbo.Jobs AS j inner join Entrada.dbo.Clinics AS c ON j.ClinicId = c.CLinicID
where j.ClinicId = @Clinic and (j.AppointmentDate BETWEEN @Begin AND @End)
ORDER BY DictatorID, AppointmentDate




GO
