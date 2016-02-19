SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | get job details by JobID and ClinicID
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobByClinicIDAndJobIDGet 838920, 210
*/

CREATE PROCEDURE [dbo].[sp_JobByClinicIDAndJobIDGet] 
	@JobID bigint,
	@ClinicID smallint
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT Jobs.JobNumber, Jobs.ClinicID, Jobs.JobTypeID FROM Jobs WHERE JobID = @JobID AND ClinicID = @ClinicID

END
GO
