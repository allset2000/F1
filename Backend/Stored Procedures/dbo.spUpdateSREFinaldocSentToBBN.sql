SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
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
CREATE PROCEDURE [dbo].[spUpdateSREFinaldocSentToBBN]  
(  
 @vvcrJobNumber VARCHAR(20),
 @bitIsSentToBBN bit
)  
AS  
BEGIN
	IF @bitIsSentToBBN = 1 
		BEGIN
			UPDATE  jobs SET FinaldocSentToBBN = 1,IsLockedForProcessing=0 WHERE JobNumber = @vvcrJobNumber 
		END 
	ELSE
		BEGIN
			UPDATE  jobs SET IsLockedForProcessing=0 WHERE JobNumber = @vvcrJobNumber  
		END
END
GO
