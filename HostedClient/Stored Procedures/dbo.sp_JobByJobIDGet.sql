SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 03/10/2016  | sharif shaik        | get job status by JobID
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobByJobIDGet 5752245
*/

CREATE PROCEDURE [dbo].[sp_JobByJobIDGet] 
	@JobID bigint	
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT Jobs.[Status] FROM Jobs WHERE JobID = @JobID

END
GO
