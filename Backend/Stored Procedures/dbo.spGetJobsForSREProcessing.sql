/******************************    
** File:  spGetJobsForSREProcessing.sql    
** Name:  spGetJobsForSREProcessing    
** Desc:  Get the jobs with given status and updates the IsLockedForProcessing column to 1    
** Auth:  Suresh    
** Date:  13/Feb/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spGetJobsForSREProcessing 110, 5,5  
*******************************/

CREATE PROCEDURE dbo.spGetJobsForSREProcessing    
(    
 @vintStatus  INT,    
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
 IsLockedForProcessing bit,  
 SRETypeId int,
 ProcessTypeId  int   
 )  
   
 DECLARE @IsLockedForProcessing BIT    
 -- Get nVoQ Jobs  
  INSERT INTO @TempJobs    
  SELECT top (@vintNVoQJobCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.IsLockedForProcessing,  
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId,2 as ProcessTypeId      
  FROM  Jobs jb    
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID  
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID  
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber    
  WHERE  js.Status = 110  
  AND jb.IsLockedForProcessing = 0  
  --AND jb.DictatorID = 'nvoqaposton'  
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 1) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=1))  
  ORDER BY JB.Stat desc, JB.ReceivedOn desc  
   
 -- Get BBN Jobs  
  INSERT INTO @TempJobs   
  SELECT top (@vintBBNJobCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.IsLockedForProcessing,  
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId,2 as ProcessTypeId      
  FROM  Jobs jb    
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID  
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID  
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber    
  WHERE  js.Status = 110  
  AND jb.IsLockedForProcessing = 0  
  --AND jb.DictatorID = 'nvoqaposton'  
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 2) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=2))  
  ORDER BY JB.Stat desc, JB.ReceivedOn desc  
  
  --update the jobs to IsLockedForProcessing  
  UPDATE JOBS Set IsLockedForProcessing =1 FROM JOBS JB   
  INNER JOIN @TempJobs TJ on JB.JobNumber = TJ.JobNumber  
  WHERE JB.IsLockedForProcessing=0  
    
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