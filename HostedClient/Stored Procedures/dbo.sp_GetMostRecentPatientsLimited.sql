
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Tamojit Chakraborty
-- Create date: 03/10/2015
-- Description:	Returns the last X patients the dictator has seen.This procedure is written in leu of the GetMostRecentPatientsLimited method present in the API
-- Full Path of the method of the api..... \\dictate-api-ws\external\common-net\Entrada.Data.SqlServer\Client\PatientSqlRepository.cs
-- =============================================
CREATE  PROCEDURE [dbo].[sp_GetMostRecentPatientsLimited] 
	-- Add the parameters for the stored procedure here
	@dictatorId INT, @count INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

DECLARE @queId AS INT

--Checking and dropping temp table 
IF OBJECT_ID('tempdb..#tmppat') IS NOT NULL 
	DROP TABLE #tmppat

SELECT @queId= QueueID 
FROM Queue_Users 
WHERE DictatorID = @dictatorId

SELECT TOP (@count)  Encounters.PatientID INTO #tmppat
FROM Jobs 
INNER JOIN Encounters ON Jobs.EncounterID = Encounters.EncounterID 
INNER JOIN Dictations ON Dictations.JobID = Jobs.JobID 
WHERE DictatorID = @dictatorId OR QueueID = @queId
GROUP BY Encounters.PatientID




SELECT  p.PatientID ,
        p.ClinicID ,
        p.MRN ,
        p.AlternateID ,
        p.FirstName ,
        p.MI ,
        p.LastName ,
        p.Suffix ,
        p.Gender ,
        p.Address1 ,
        p.Address2 ,
        p.City ,
        p.State ,
        p.Zip ,
        CASE WHEN ISDATE(dob) = 1 THEN convert(varchar(10),cast(dob as date),101) ELSE '01/01/1900' END as 'DOB',
        p.Phone1 ,
        p.Phone2 ,
        p.Fax1 ,
        p.Fax2 ,
        p.PrimaryCareProviderID ,
        t.PatientID
       from dbo.Patients p	INNER JOIN  #tmppat t  ON p.PatientID=t.PatientID
END


GO
