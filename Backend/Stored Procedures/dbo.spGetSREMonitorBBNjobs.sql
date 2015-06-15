/******************************          
** File:  spGetSREMonitorBBNjobs.sql          
** Name:  spGetSREMonitorBBNjobs          
** Desc:  Get the given number of In-processing BBN jobs with given status          
** Auth:  Suresh          
** Date:  8/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
      
Create PROCEDURE [dbo].[spGetSREMonitorBBNjobs] 
(          
 @vintstatusCode  INT,        
 @vintrowsCount INT,  
 @vintProcessDuration INT        
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
 ProcessTypeId int,  
 [Status] int   
 )    
 BEGIN            
  INSERT INTO @TempJobs        
  SELECT top (@vintrowsCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.IsLockedForProcessing,    
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId,2 as ProcessTypeId,js.status  
  FROM  Jobs jb        
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID      
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID      
  INNER JOIN  JobStatusA js ON jb.JobNumber = js.JobNumber        
  WHERE  js.Status = @vintstatusCode and jb.Jobstatus <> 135    
  AND jb.IsLockedForProcessing = 1      
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 2) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=2))  
  AND DATEDIFF(HOUR, js.StatusDate, GETDATE()) > @vintProcessDuration  
 END          
     
 --update the jobs to IsProcessed       
 UPDATE Jobs Set Jobstatus = 135 FROM Jobs JB             
 INNER JOIN @TempJobs TJ on JB.JobNumber = TJ.JobNumber        
 SET @UpdatedJobCount = @@ROWCOUNT            
 SELECT @SelectedJobCount = COUNT(*) FROM @TempJobs           
 --In case when this proc is executed in parallel by multiple instances of the SRE App we need            
 --to make sure we don't return the same job twice            
 IF (@UpdatedJobCount <> @SelectedJobCount)            
  BEGIN            
   ROLLBACK TRANSACTION            
   DECLARE @ErrorMsg varchar(200)            
   SET @ErrorMsg = '[spGetSREMonitorBBNjobs] - Job Count mismatch: @JobCount =' + convert(varchar, @SelectedJobCount) + ' @@RowCount =' + convert(varchar, @UpdatedJobCount)            
   RAISERROR (@ErrorMsg, 16, 1)       
   RETURN;            
  END           
 SELECT * FROM @TempJobs          
 COMMIT TRANSACTION               
END   

