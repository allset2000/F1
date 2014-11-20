SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/18/2014
-- Description: SP used to obtain the jobnumber / information for Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobByClinicFilename](
	@ClinicId int,
	@Filename varchar(20)
)  AS 
BEGIN

	SELECT jc.JobNumber,jc.FileName,jc.DictatorID,jc.MD5
	FROM Jobs_Client jc
		INNER JOIN Jobs j on j.JobNumber = jc.JobNumber
	WHERE jc.FileName = @Filename and j.ClinicID = @ClinicId

END


GO
