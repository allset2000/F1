SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* =======================================================
Author:			Sindhuri Manne
Create date:	11/5/14
Description:	Implementation report that shows completed jobs
-- ddorsey 1/7/2015 recreated report to be used for client
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_Account_CompletedJobs]
	

	@ReceivedOn Datetime,
	@ReceivedOn2 Datetime,
	@PayTypeVar varchar(10)
	
	AS

SELECT qdh.ClinicID, qdh.DictatorID, qdh.JobNumber, j.JobType, j.AppointmentDate, j.ContextName, 
j.IsGenericJob, qdh.DeliveredOn, qdh.Method, JDM.Description, C.Clinicname
FROM Entrada.dbo.qryJobDeliveryHistoryView AS qdh 
INNER JOIN Entrada.dbo.Jobs AS j ON qdh.JobNumber = j.JobNumber 
INNER JOIN Entrada.dbo.JobsDeliveryMethods AS JDM ON qdh.Method = JDM.JobDeliveryID
INNER JOIN Entrada.dbo.Clinics C ON J.ClinicID = C.ClinicID
WHERE c.Cliniccode = @PayTypeVar AND (j.AppointmentDate BETWEEN @ReceivedOn AND @ReceivedOn2) 
ORDER BY qdh.DeliveredOn



GO
