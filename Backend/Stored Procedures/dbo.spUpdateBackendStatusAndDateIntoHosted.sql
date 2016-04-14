
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************      
** File:  spUpdateBackendStatusAndDateIntoHosted.sql      
** Name:  spUpdateBackendStatusAndDateIntoHosted      
** Desc:  Update the Backend Status and date time while moving one status to another status into Hosted DB
** Auth:  Suresh      
** Date:  14/April/2016      
**************************      
** Change History      
*************************      
* PR   Date     Author  Description       
* --   --------   -------   ------------------------------------      
*******************************/
CREATE PROCEDURE [dbo].[spUpdateBackendStatusAndDateIntoHosted]  
(  
 @vvcrJobNumber VARCHAR(20),  
 @vsintStatus SMALLINT
)  
AS  
BEGIN

	UPDATE [dbo].[EH_Jobs] SET UpdatedDateInUTC = GETUTCDATE() , BackendStatus = @vsintStatus 
	FROM EH_Jobs JH
	INNER JOIN JOBS_CLIENT JC 
	ON JC.filename=JH.jobnumber
	WHERE JC.jobnumber = @vvcrJobNumber

END 

		
GO
