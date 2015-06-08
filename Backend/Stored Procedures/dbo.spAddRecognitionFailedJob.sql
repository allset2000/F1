/******************************      
** File:  spAddRecognitionFailedJob.sql      
** Name:  spAddRecognitionFailedJob      
** Desc:  Add the record in recognitionfailedjobs table      
** Auth:  Suresh      
** Date:  27/Mar/2015      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/  
 
CREATE PROCEDURE [dbo].[spAddRecognitionFailedJob]  
(  
 @vvcrJobNumber VARCHAR(20),   
 @vintNumTries INT  
)  
AS  
BEGIN  
 INSERT INTO RecognitionFailedJobs(JobNumber,NumTries)  
 VALUES(@vvcrJobNumber,@vintNumTries)  
END  
  
  