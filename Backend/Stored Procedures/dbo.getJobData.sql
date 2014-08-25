
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getJobData] (
   @JobNumber varchar(20)
) AS
	SELECT [DictatorID], [ClinicID], [ClinicName], [Location], '' AS LocationName,
		   CONVERT(varchar, [AppointmentDate], 101) AS AppointmentDate,
		   LTRIM(RTRIM(SUBSTRING(CONVERT(varchar, [AppointmentTime], 22), 9, 15))) AS AppointmentTime,
		   [JobType], 
		   [Stat] ,[CC], [Duration], 
		   CONVERT(varchar, [DictationDate], 101) AS DictationDate,
		   LTRIM(RTRIM(SUBSTRING(CONVERT(varchar, [DictationTime], 22), 9, 15))) AS DictationTime, 
		   ISNULL(ParentJobNumber, '') AS ParentJobNumber, 
		   [TemplateName]
	FROM   dbo.vwMedicalJobs
  WHERE (JobNumber = @JobNumber)
RETURN
GO
