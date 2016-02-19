SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | get job images details by JobID
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobImagesGet 838920
*/

CREATE PROCEDURE [dbo].[sp_JobImagesGet] 
	@JobID bigint	
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT JobImages.ImageID, JobImages.JobID, JobImages.ImagePath, JobImages.[Description]  
	FROM JobImages LEFT JOIN JobsDeliveryTracking on JobImages.ImageID = JobsDeliveryTracking.ImageID 
	WHERE JobImages.JobID = @JobID AND JobsDeliveryTracking.JobID IS NULL

END
GO
