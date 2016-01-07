SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 12/22/2015    
-- Description: SP used to get J2D Error Code to update
-- =============================================    
CREATE PROCEDURE [dbo].[sp_getErrorDefinitionById]
(
	@ErrorDefinitionID INT
)
AS
BEGIN
	SELECT [ErrorDefinitionID]
		  ,[ErrorCode]
		  ,[ErrorMessage]
		  ,[ResolutionGuide]
		  ,[ErrorSourceType]
		  ,[AllowEncounterID]
		  ,[AllowDocumentID]
		  ,[AllowDocumentTypeID]
	  FROM [dbo].[ErrorDefinitions]
	  WHERE [ErrorDefinitionID] = @ErrorDefinitionID
END


GO
