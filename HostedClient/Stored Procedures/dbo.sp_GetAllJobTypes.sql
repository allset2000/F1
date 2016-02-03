SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 02/02/2016
-- Description: SP used to get All JobTypes
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetAllJobTypes]
(
	@ClinicId INT	
)
AS
BEGIN
	SELECT 
		J.*
		, JC.JobTypeCategory 
	FROM JobTypes J 
		INNER JOIN JobTypeCategory JC ON JC.JobTypeCategoryId = J.JobTypeCategoryId 
	WHERE ClinicID = @ClinicId AND Deleted = 0
END
GO
