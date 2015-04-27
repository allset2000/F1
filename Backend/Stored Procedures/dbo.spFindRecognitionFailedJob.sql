/******************************    
** File:  spFindRecognitionFailedJob.sql    
** Name:  spFindRecognitionFailedJob    
** Desc:  Get the Numtries value based on jobnumber    
** Auth:  Suresh    
** Date:  27/Mar/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
*******************************/

CREATE PROCEDURE [dbo].[spFindRecognitionFailedJob]
(	
	@vvcrJobNumber		VARCHAR(20)
)
AS
BEGIN
	SELECT
			NumTries 
	FROM	RecognitionFailedJobs
	WHERE	JobNumber = @vvcrJobNumber
END






