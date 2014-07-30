SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobsToDeliver_ByClinic] AS
SELECT COUNT(*) AS NumJobs, ClinicID, ClinicName, Method FROM qryJobsToDeliver
WHERE Method<>700
GROUP BY ClinicID, ClinicName, Method
--ORDER BY ClinicID, Method
GO
