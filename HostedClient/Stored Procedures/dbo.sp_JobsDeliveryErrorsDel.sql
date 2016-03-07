
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | delete record from JobsDeliveryErrors by JobID and ImageID
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobsDeliveryErrorsDel 0, 0
*/

CREATE PROCEDURE [dbo].[sp_JobsDeliveryErrorsDel] 
	@JobID bigint,
	@ImageID bigint = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM JobsDeliveryErrors WHERE JobID = @JobID AND (@ImageID IS NULL or  ImageID = @ImageID)

END
GO
