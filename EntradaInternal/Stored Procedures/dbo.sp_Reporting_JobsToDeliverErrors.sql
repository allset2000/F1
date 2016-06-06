SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*  =======================================================
Author:			Sindhuri Manne 
Create date:	10/17/2014
Description:	 Gives error messages being generated for different clinics.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_JobsToDeliverErrors]

@ClinicID smallint

AS

SELECT        JTDE.Message, JTDE.ErrorMessage, JTDE.DeliveryId, j.JobNumber, j.DictatorID, j.AppointmentDate, j.JobType, j.EditorID, j.ClinicID, JT.Status, MAX(JT.StatusDate) 
                         AS StatusDate, C.ClinicName
FROM            Entrada.dbo.JobsToDeliverErrors AS JTDE INNER JOIN
                         Entrada.dbo.JobsToDeliver AS JTD ON JTD.DeliveryID = JTDE.DeliveryId INNER JOIN
                         Entrada.dbo.Jobs AS j ON j.JobNumber = JTD.JobNumber INNER JOIN
                         Entrada.dbo.JobTracking AS JT ON JT.JobNumber = j.JobNumber INNER JOIN
                         Entrada.dbo.StatusCodes AS SC ON SC.StatusID = JT.Status INNER JOIN
                         Entrada.dbo.Clinics AS C ON C.ClinicID = j.ClinicID
WHERE        (j.ClinicID = @ClinicId) AND (SC.StatusID = 260)
GROUP BY JTDE.Message, JTDE.ErrorMessage, JTDE.DeliveryId, j.JobNumber, j.DictatorID, j.AppointmentDate, j.JobType, j.EditorID, j.ClinicID, JT.Status, C.ClinicName
ORDER BY C.ClinicName


GO
