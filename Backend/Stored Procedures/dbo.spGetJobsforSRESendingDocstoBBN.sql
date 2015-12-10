
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetJobsforSRESendingDocstoBBN.sql          
** Name:  spGetJobsforSRESendingDocstoBBN          
** Desc:  Get the given number of completed BBN jobs with given status          
** Auth:  Suresh          
** Date:  11/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetJobsforSRESendingDocstoBBN] 
(          
 @vintrowsCount INT       
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
 [Status] int,
 Doc varbinary(max)   
 )    
 BEGIN            
  INSERT INTO @TempJobs  
  SELECT top (@vintrowsCount) jb.JobNumber, jb.DictatorID,jb.ClinicID, jb.Vocabulary, jb.Stat, jb.ReceivedOn,jb.IsLockedForProcessing,    
  CASE WHEN (d.SRETypeId is null) then c.SRETypeId else d.SRETypeId end SRETypeId,2 as ProcessTypeId,js.status,jd.doc as Document 
  FROM  Jobs jb        
  INNER JOIN dbo.Dictators d on jb.DictatorID = d.DictatorID      
  INNER JOIN Clinics c on jb.ClinicID = c.ClinicID      
  INNER JOIN JobStatusB js ON jb.JobNumber = js.JobNumber
  INNER JOIN jobs_documents jd on jb.jobnumber = jd.jobnumber
  CROSS APPLY (SELECT TOP 1 JOBNUMBER FROM JobDeliveryHistory jh WHERE jb.jobnumber=jh.jobnumber) jh 
  WHERE  jb.IsLockedForProcessing=0 AND jb.FinaldocSentToBBN <> 1
  AND ((d.SRETypeId IS NOT NULL AND d.SRETypeId = 2) or (d.SRETypeId is NULL AND C.SRETypeId IS NOT NULL AND C.SRETypeID=2))  

 --update the jobs to jobstatus       
 UPDATE Jobs Set IsLockedForProcessing=1 FROM Jobs JB             
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
			SET @ErrorMsg = '[spGetJobsforSRESendingDocstoBBN] - Job Count mismatch: @JobCount =' + convert(varchar, @SelectedJobCount) + ' @@RowCount =' + convert(varchar, @UpdatedJobCount)            
			RAISERROR (@ErrorMsg, 16, 1)       
			RETURN;            
			END           
			SELECT * FROM @TempJobs          
			COMMIT TRANSACTION               
		END   
END
GO
