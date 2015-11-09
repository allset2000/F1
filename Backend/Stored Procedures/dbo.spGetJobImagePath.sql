/******************************          
** File:  spGetJobImagePath.sql          
** Name:  spGetJobImagePath          
** Desc:  Get the Job Image Path based on job number
** Auth:  Suresh          
** Date:  18/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spGetJobImagePath] 
(          
 @vvcrJobNumber VARCHAR(20),
 @vintImageID INT      
)           
AS          
BEGIN       
	SELECT ImagePath
	FROM jobs_images
	WHERE JobNumber=@vvcrJobNumber 
		AND ImageID=@vintImageID
END   

