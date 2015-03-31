SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 03/21/2015
	Version: 1.0
	Details: Gets log configuration per application code
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script was changed?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_GetLogConfigurationByApplicationCode](
	@ApplicationCode VARCHAR(50)
)
AS
BEGIN
	SELECT *
	FROM [dbo].[LogConfiguration]
	WHERE [ApplicationCode] = @ApplicationCode
END
GO
