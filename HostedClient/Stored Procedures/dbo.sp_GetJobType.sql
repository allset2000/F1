SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================    
-- Author: Santhosh
-- Create date: 02/02/2016
-- Description: SP used to get JobType by JobTypeId
-- =============================================    
CREATE PROCEDURE [dbo].[sp_GetJobType]
(
	@ClinicId INT
	, @JobTypeId INT
)
AS
BEGIN
	SELECT 
		J.*
		, JC.JobTypeCategory 
	FROM JobTypes J 
		INNER JOIN JobTypeCategory JC ON JC.JobTypeCategoryId = J.JobTypeCategoryId 
	WHERE JobTypeID = @JobTypeId AND ClinicID = @ClinicId
END
GO
