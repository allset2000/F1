SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/* =======================================================
Author:			Sindhuri Manne
Create date:	11/13/14
Description:	Implementation report shows jobs documentation time
======================================================= */
	
	CREATE PROCEDURE [dbo].[sp_Reporting_DocumentationTime]
	
@ClinicID int,
@BeginDate Datetime,
@EndDate Datetime
	
	AS

SELECT  j.DictatorID, j.JobNumber, j.ClinicID, j.AppointmentDate, j.Duration, c.ClinicName
FROM Entrada.dbo.Jobs AS j 
INNER JOIN Entrada.dbo.Clinics AS c ON j.ClinicID = c.ClinicID
WHERE (j.ClinicID = @ClinicId) AND (j.AppointmentDate BETWEEN @BeginDate AND @EndDate)
order by     j.DictatorID, j.AppointmentDate



GO
