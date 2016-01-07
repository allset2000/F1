SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 12/24/2015    
-- Description: SP used to get all Error Codes
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetAllErrorDefinitions]
AS
BEGIN
	SELECT ErrorDefinitions.[ErrorDefinitionID]
		  ,ErrorDefinitions.[ErrorCode]
		  ,ErrorDefinitions.[ErrorMessage]
		  ,ErrorDefinitions.[ResolutionGuide]
		  ,ErrorDefinitions.[ErrorSourceType]
		  ,ErrorDefinitions.[AllowEncounterID]
		  ,ErrorDefinitions.[AllowDocumentID]
		  ,ErrorDefinitions.[AllowDocumentTypeID]		
		  ,ErrorSourceTypes.ErrorSourceType AS 'ErrorSourceDescription'
		  , (SELECT COUNT(1) FROM JobsDeliveryErrors WHERE ErrorCode = [ErrorDefinitions].ErrorCode) + (SELECT COUNT(1) FROM ENTRADA.DBO.JobsToDeliverErrors WHERE ErrorCode = [ErrorDefinitions].ErrorCode) AS ErrorCodeLogCount
	  FROM [dbo].[ErrorDefinitions]
	  INNER JOIN ErrorSourceTypes ON ErrorDefinitions.ErrorSourceType = ErrorSourceTypes.ErrorSourceTypeID
END


GO
