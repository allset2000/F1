/******************************          
** File:  spGetJobImages.sql          
** Name:  spGetJobImages          
** Desc:  Get the Job Images Path based on job number
** Auth:  Suresh          
** Date:  18/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spGetJobImages] 
(          
 @vvcrJobNumber VARCHAR(20)      
)           
AS          
BEGIN       
	SELECT ImageID,
		JobNumber,
		ImagePath
	FROM jobs_images
	WHERE JobNumber=@vvcrJobNumber
END   

