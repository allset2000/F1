SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 12/30/2015    
-- Description: SP used to Delete Error Code
-- =============================================    
CREATE PROCEDURE [dbo].[sp_DeleteErrorCode]
(
	@ErrorDefinitionId INT	
)
AS
BEGIN
	DELETE FROM ErrorDefinitions WHERE ErrorDefinitionId = @ErrorDefinitionId
	SELECT 1
END
GO
