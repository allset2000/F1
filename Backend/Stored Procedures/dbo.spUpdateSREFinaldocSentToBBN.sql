/******************************      
** File:  spUpdateSREFinaldocSentToBBN.sql      
** Name:  spUpdateSREFinaldocSentToBBN      
** Desc:  Update the FinaldocSentToBBN flag after sent the Final doc To BBN 
** Auth:  Suresh      
** Date:  11/Jun/2015      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/
alter PROCEDURE [dbo].[spUpdateSREFinaldocSentToBBN]  
(  
 @vvcrJobNumber VARCHAR(20),
 @bitIsSentToBBN bit
)  
AS  
BEGIN TRANSACTION  
	IF @bitIsSentToBBN = 1 
		BEGIN
			UPDATE  jobs SET FinaldocSentToBBN = 1 WHERE JobNumber = @vvcrJobNumber 
		END 
	ELSE
		BEGIN
			UPDATE  jobs SET jobstatus = 360 WHERE JobNumber = @vvcrJobNumber  
		END
IF @@ERROR <> 0  
 BEGIN  
    -- Rollback the transaction  
    ROLLBACK  
    -- Raise an error and return  
    RAISERROR ('Error in Insert or Update Status.', 16, 1)  
    RETURN  
 END  
COMMIT