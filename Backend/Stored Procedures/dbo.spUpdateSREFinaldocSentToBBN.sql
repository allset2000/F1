
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
DECLARE @numTime INT 
SET @numTime = 0 

	IF @bitIsSentToBBN = 1 
		BEGIN
			UPDATE  jobs SET FinaldocSentToBBN = 1,IsLockedForProcessing=0 WHERE JobNumber = @vvcrJobNumber 
		END 
	ELSE
		BEGIN
			SELECT @numTime= ProcessFailureCount FROM dbo.Jobs WHERE JobNumber=@vvcrJobNumber
			IF @numTime < 5
				BEGIN	
				SET @numTime = @numTime + 1
				UPDATE  jobs SET IsLockedForProcessing=0,ProcessFailureCount=@numTime WHERE JobNumber = @vvcrJobNumber  
				END	
		END
END
GO
