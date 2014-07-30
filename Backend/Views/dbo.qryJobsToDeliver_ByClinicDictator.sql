SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryJobsToDeliver_ByClinicDictator] AS
SELECT COUNT(*) AS NumJobs, ClinicID, ClinicName, DictatorID, Method FROM qryJobsToDeliver
WHERE Method<>700
GROUP BY ClinicID, ClinicName, DictatorID, Method
--ORDER BY ClinicID, Method
GO
