/******************************          
** File:  spGetJob.sql          
** Name:  spGetJob          
** Desc:  Get the Job info based on job number
** Auth:  Suresh          
** Date:  19/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spGetJob] 
(          
 @vvcrJobNumber VARCHAR(20)
)           
AS          
BEGIN       
	SELECT * FROM Jobs WHERE JobNumber = @vvcrJobNumber 
END   

