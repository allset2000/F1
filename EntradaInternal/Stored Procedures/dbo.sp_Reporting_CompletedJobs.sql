SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* =======================================================
Author:			Sindhuri Manne
Create date:	11/5/14
Description:	Implementation report that shows completed jobs
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_CompletedJobs]
	
	@DateType BIT,
	@BeginDate Datetime,
	@EndDate Datetime,
	@ClinicId smallint
	
	AS

SELECT qdh.ClinicID, qdh.DictatorID, qdh.JobNumber, j.JobType, j.AppointmentDate, j.ContextName, 
j.IsGenericJob, qdh.DeliveredOn, qdh.Method, JDM.Description
FROM Entrada.dbo.qryJobDeliveryHistoryView AS qdh 
INNER JOIN Entrada.dbo.Jobs AS j ON qdh.JobNumber = j.JobNumber 
INNER JOIN Entrada.dbo.JobsDeliveryMethods AS JDM ON qdh.Method = JDM.JobDeliveryID
WHERE (qdh.ClinicID in (select [Value] from dbo.split(@ClinicId,','))) AND (@DateType = 1) AND (j.AppointmentDate BETWEEN @BeginDate AND @EndDate) OR
(qdh.ClinicID in (select [Value] from dbo.split(@ClinicId,','))) AND (@DateType = 0) AND (qdh.DeliveredOn BETWEEN @BeginDate AND @EndDate)
ORDER BY qdh.DeliveredOn


GO
