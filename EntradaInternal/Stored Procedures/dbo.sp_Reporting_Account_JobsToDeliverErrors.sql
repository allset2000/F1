SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*  =======================================================
Author:			Sindhuri Manne 
Create date:	10/17/2014
Description:	 Gives error messages being generated for different clinics.
--- Recreated report to use for clients
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Account_JobsToDeliverErrors]

	@ReceivedOn datetime = NULL, 
	@ReceivedOn2 datetime = NULL,
	@PayTypeVar varchar(100) 

AS

SELECT        JTDE.Message, JTDE.ErrorMessage, JTDE.DeliveryId, j.JobNumber, j.DictatorID, j.AppointmentDate, j.JobType, j.EditorID, j.ClinicID, JT.Status, MAX(JT.StatusDate) 
                         AS StatusDate, C.ClinicName, P.MRN
FROM            Entrada.dbo.JobsToDeliverErrors AS JTDE INNER JOIN
                         Entrada.dbo.JobsToDeliver AS JTD ON JTD.DeliveryID = JTDE.DeliveryId INNER JOIN
                         Entrada.dbo.Jobs AS j ON j.JobNumber = JTD.JobNumber INNER JOIN
                         Entrada.dbo.JobTracking AS JT ON JT.JobNumber = j.JobNumber INNER JOIN
                         Entrada.dbo.StatusCodes AS SC ON SC.StatusID = JT.Status INNER JOIN
                         Entrada.dbo.Clinics AS C ON C.ClinicID = j.ClinicID INNER JOIN
                         Entrada.dbo.Jobs_Patients P ON JTD.Jobnumber = P.Jobnumber
WHERE        C.Cliniccode = @PayTypeVar AND (SC.StatusID = 260) 
AND JT.StatusDate between @ReceivedOn and @ReceivedOn2
GROUP BY JTDE.Message, JTDE.ErrorMessage, JTDE.DeliveryId, j.JobNumber, j.DictatorID, j.AppointmentDate, j.JobType, j.EditorID, j.ClinicID, JT.Status, C.ClinicName, P.MRN
ORDER BY C.ClinicName, MAX(JT.StatusDate)



GO
