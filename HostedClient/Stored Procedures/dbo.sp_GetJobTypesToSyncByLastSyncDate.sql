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
		SELECT JobTypeID,
		     CASE WHEN Deleted = 1 THEN 500 ELSE 100 END AS [State]
		 FROM dbo.JobTypes
		 WHERE ClinicID=@ClinicId
		 AND ISNULL(UpdatedDateInUTC,GETUTCDATE())>@LastSyncDate 
END


GO
