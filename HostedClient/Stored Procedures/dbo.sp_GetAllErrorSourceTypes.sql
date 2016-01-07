SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 12/24/2015    
-- Description: SP used to get all Error Source Types
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetAllErrorSourceTypes]
AS
BEGIN
	SELECT ErrorSourceTypeID, ErrorSourceType
	FROM ErrorSourceTypes
END
GO
