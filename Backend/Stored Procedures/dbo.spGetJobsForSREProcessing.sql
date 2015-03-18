/******************************    
** File:  spGetJobs.sql    
** Name:  spGetJobs    
** Desc:  Get the jobs with given status and updates the Isprocessed column to 1    
** Auth:  Suresh    
** Date:  13/Feb/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetJobsForSREProcessing 110, 5,5,5  
*******************************/    
CREATE PROCEDURE [dbo].[spGetJobsForSREProcessing]    
(    
 @vintStatus  INT,    
 @vintNuanceJobCount INT,  
 @vintNVoQJobCount INT,  
 @vintBBNJobCount INT  
)     
AS    
BEGIN    
BEGIN TRANSACTION  
DECLARE @SelectedJobCount INT  
DECLARE @UpdatedJobCount INT  
  
 DECLARE @TempJobs TABLE(  
 JobNumber VarChar(20),  
 DictatorID varchar(50),  
 ClinicID smallint,  
 Vocabulary varchar(255),  
 Stat bit,  
 ReceivedOn datetime,  
 IsProcessed bit,  
 SRETypeId int  
 )  
   
 DECLARE @IsProcessed BIT    
 -- Get nVoQ Jobs  
  INSERT INTO @TempJobs    
  SELECT top (@vintNVoQJobCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.Isprocessed,  
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId   
  FROM  Jobs jb    
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID  
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID  
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber    
  WHERE  js.Status = 110  
  AND jb.IsProcessed = 0  
  --AND jb.DictatorID in ('nvoqaposton','qaasyontz')  
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 1) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=1))  
  ORDER BY JB.Stat desc, JB.ReceivedOn desc  
   
 -- Get Naunce Jobs  
  INSERT INTO @TempJobs   
  SELECT top (@vintNuanceJobCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.Isprocessed,  
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId   
  FROM  Jobs jb    
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID  
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID  
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber    
  WHERE  js.Status = 110  
  AND jb.IsProcessed = 0  
  --AND jb.DictatorID = 'tscwedwards'  
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 2) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=2))  
  ORDER BY JB.Stat desc, JB.ReceivedOn desc  
  
 -- Get BBN Jobs  
  INSERT INTO @TempJobs   
  SELECT top (@vintBBNJobCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.Isprocessed,  
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId   
  FROM  Jobs jb    
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID  
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID  
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber    
  WHERE  js.Status = 110  
  AND jb.IsProcessed = 0  
  --AND jb.DictatorID = 'nvoqaposton'  
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 3) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=3))  
  ORDER BY JB.Stat desc, JB.ReceivedOn desc  
  
  --update the jobs to IsProcessed  
  UPDATE JOBS Set IsProcessed =1 FROM JOBS JB   
  INNER JOIN @TempJobs TJ on JB.JobNumber = TJ.JobNumber  
  WHERE JB.IsProcessed=0  
    
  SET @UpdatedJobCount = @@ROWCOUNT  
  SELECT @SelectedJobCount = COUNT(*) FROM @TempJobs  
  
 --In case when this proc is executed in parallel by multiple instances of the SRE App we need  
 --to make sure we don't return the same job twice  
   
 IF (@UpdatedJobCount <> @SelectedJobCount)  
 BEGIN  
  ROLLBACK TRANSACTION  
  DECLARE @ErrorMsg varchar(200)  
  SET @ErrorMsg = '[spGetJobsForSREProcessing] - Job Count mismatch: @JobCount =' + convert(varchar, @SelectedJobCount) + ' @@RowCount =' + convert(varchar, @UpdatedJobCount)  
  RAISERROR (@ErrorMsg, 16, 1)    
  RETURN;  
 END  
   
 SELECT * FROM @TempJobs ORDER BY Stat desc, ReceivedOn desc  
   
 COMMIT TRANSACTION  
  
   
END 