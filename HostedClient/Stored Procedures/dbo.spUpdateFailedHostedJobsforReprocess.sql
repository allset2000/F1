SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spUpdateFailedHostedJobsforReprocess.sql          
** Name:  spUpdateFailedHostedJobsforReprocess          
** Desc:  Reset all failed jobs for reprocess based on status
** Auth:  Suresh          
** Date:  16/Feb/2016          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------       
*******************************/      
CREATE PROCEDURE [dbo].[spUpdateFailedHostedJobsforReprocess] 
(
	 @vintStatus INT,
	 @vintFaileCount INT,
	 @vvcrJobNumber VARCHAR(20)  = NULL
)           
AS          
BEGIN 
	 -- Reset all failed jobs for reprocess based on status in Hosted DB
	  IF @vvcrJobNumber IS NULL OR @vvcrJobNumber =''
	  BEGIN	
			UPDATE [dbo].[Jobs] SET processfailurecount =0 
			FROM [dbo].[Jobs] J
			WHERE J.Status = @vintStatus AND processfailurecount > @vintFaileCount
		END	
	ELSE
	BEGIN
	-- Reset all failed job for reprocess based on Job Number in Hosted DB
		UPDATE [dbo].[Jobs] SET processfailurecount =0  FROM [dbo].[Jobs] 
		WHERE JobNumber = @vvcrJobNumber
	END	
END

GO
