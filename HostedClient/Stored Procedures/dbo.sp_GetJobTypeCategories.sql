SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 01/14/2016
-- Description: SP used to get all JobType Categories
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetJobTypeCategories]
AS
BEGIN
	SELECT JobTypeCategoryId, JobTypeCategory
	FROM JobTypeCategory
END
GO
