    SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************        
** File:  spGetJobsForSRETranscoding.sql        
** Name:  spGetJobsForSRETranscoding        
** Desc:  Get the given number of jobs with given status based on ProcessFailureCount        
** Auth:  Suresh        
** Date:  13/Feb/2015        
**************************        
** Change History        
*************************        
* PR   Date     Author  Description         
* --   --------   -------   ------------------------------------     
*******************************/    
    
CREATE PROCEDURE [dbo].[spGetJobsForSRETranscoding]    
(        
 @statusCode  INT,      
 @IncludeErrors bit,    
 @ProcessFailureCount int,         
 @vintrowsCount INT        
)         
AS        
BEGIN     
 BEGIN TRANSACTION        
 DECLARE @SelectedJobCount INT          
 DECLARE @UpdatedJobCount INT          
 DECLARE @TempJobs TABLE(        
  JobID bigint,          
  JobNumber VarChar(20),        
  JobTypeID int,        
  EncounterID bigint,    
  Stat bit,        
  Status smallint,         
  ClinicID smallint,  
  ProcessTypeId smallint        
 )    
 IF (@IncludeErrors = 1)         
 BEGIN          
  INSERT INTO @TempJobs      
  SELECT TOP (@vintrowsCount) J.JobID,J.JobNumber,J.JobTypeID,J.EncounterID,J.Stat,J.Status,J.ClinicID,1 as ProcessTypeId  FROM Jobs J        
   inner join Dictations D on D.JobId = J.JobId        
   inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250        
  WHERE ((J.Status = @statusCode) AND (J.ProcessFailureCount is null or J.ProcessFailureCount <= @ProcessFailureCount) and (J.JobId NOT IN (SELECT JobId FROM Errors)))        
  ORDER BY J.STAT DESC, DT.ChangeDate      
 END        
 ELSE      
 BEGIN     
 INSERT INTO @TempJobs      
  SELECT TOP (@vintrowsCount) J.JobID,J.JobNumber,J.JobTypeID,J.EncounterID,J.Stat,J.Status,J.ClinicID,1 as ProcessTypeId  FROM Jobs J       
   inner join Dictations D on D.JobId = J.JobId        
   inner join DictationsTracking DT on DT.DictationId = D.DictationId and DT.Status = 250        
  WHERE (J.Status = @StatusCode) AND (J.ProcessFailureCount is null or J.ProcessFailureCount <= @ProcessFailureCount)        
  ORDER BY J.STAT DESC, DT.ChangeDate     
 END        
 --update the jobs to IsProcessed     
 UPDATE Jobs Set Status = 350 FROM Jobs JB           
 INNER JOIN @TempJobs TJ on JB.JobNumber = TJ.JobNumber      
 SET @UpdatedJobCount = @@ROWCOUNT          
 SELECT @SelectedJobCount = COUNT(*) FROM @TempJobs         
 --In case when this proc is executed in parallel by multiple instances of the SRE App we need          
 --to make sure we don't return the same job twice          
 IF (@UpdatedJobCount <> @SelectedJobCount)          
  BEGIN          
   ROLLBACK TRANSACTION          
   DECLARE @ErrorMsg varchar(200)          
   SET @ErrorMsg = '[spGetJobsForSRETranscoding] - Job Count mismatch: @JobCount =' + convert(varchar, @SelectedJobCount) + ' @@RowCount =' + convert(varchar, @UpdatedJobCount)          
   RAISERROR (@ErrorMsg, 16, 1)     
   RETURN;          
  END         
 SELECT * FROM @TempJobs        
 COMMIT TRANSACTION             
END 
GO
