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
BEGIN TRANSACTION  
	BEGIN TRY

		UPDATE [dbo].[EH_Jobs] SET UpdatedDateInUTC = GETUTCDATE() , BackendStatus = @vsintStatus 
		from EH_Jobs JH
		INNER JOIN JOBS_CLIENT JC 
		on JC.filename=JH.jobnumber
		where JC.jobnumber = @vvcrJobNumber

		COMMIT
	END TRY
BEGIN CATCH
	-- Rollback the transaction  
    ROLLBACK  
    -- Raise an error and return  
    RAISERROR ('Error in Insert or Update Bacekend Status into Hosted.', 16, 1)  
    RETURN  
END CATCH

		
GO
