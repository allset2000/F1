
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Raghu A
-- Create date: 11/23/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile

-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobTypesToSyncByLastSyncDate](
	 @ClinicId INT,
	 @LastSyncDate DATETIME
) AS 
BEGIN

		SET NOCOUNT ON;
		SELECT JT.JobTypeID AS ID,
		     JT.Name,
			 JT.DisableGenericJobs AS DisabledForMobile,
		     CASE WHEN JT.Deleted = 1 THEN 500 ELSE 100 END AS [State],
			 JTC.JobTypeCategoryId,
			 JTC.JobTypeCategory
		 FROM dbo.JobTypes JT WITH(NOLOCK)
		 LEFT JOIN	dbo.JobTypeCategory JTC WITH(NOLOCK) ON JT.JobTypeCategoryId=JTC.JobTypeCategoryId
		 WHERE JT.ClinicID=@ClinicId
		 AND ISNULL(JT.UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate 
END


GO
