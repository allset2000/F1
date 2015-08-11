/******************************  
** File:  spReleaseJobForJobdetailsView.sql    
** Name:  spReleaseJobForJobdetailsView    
** Desc:  un lock the job for edit in job detatails view in customer portal
** Auth:  Suresh    
** Date:  11/08/2015
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------ 
*******************************/
CREATE PROCEDURE [dbo].[spReleaseJobForJobdetailsView] 
(    
@vvcrJobNumber VARCHAR(20)
)     
AS    
BEGIN 
	UPDATE jobs SET LokedbyUserForJobDetailsView=null WHERE jobnumber=@vvcrJobNumber
END 
GO
