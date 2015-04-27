/******************************    
** File:  spUpdateRecognitionFailedJob.sql    
** Name:  spUpdateRecognitionFailedJob    
** Desc:  update the record in recognition failed jobs table    
** Auth:  Suresh    
** Date:  27/Mar/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
*******************************/

CREATE PROCEDURE [dbo].[spUpdateRecognitionFailedJob]
(
	@vvcrJobNumber	VARCHAR(20),	
	@vintNumTries	INT
)
AS
BEGIN
	UPDATE	RecognitionFailedJobs
	SET		NumTries = @vintNumTries
	WHERE	JobNumber =  @vvcrJobNumber
END


