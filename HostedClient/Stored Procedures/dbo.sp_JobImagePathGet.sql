SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | get job imagepath details by JobID
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobImagePathGet 838920, 210, 1737
*/

CREATE PROCEDURE [dbo].[sp_JobImagePathGet] 
	@JobID bigint,
	@ClinicID smallint,	
	@ImageID bigint
	
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT JobImages.ImagePath FROM Jobs INNER JOIN JobImages ON Jobs.JobID = JobImages.JobID WHERE Jobs.jobID = @JobID AND Jobs.ClinicID = @ClinicID AND JobImages.ImageID = @ImageID

END
GO
