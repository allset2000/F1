SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/24/2015
-- Description: SP used to get a System Configuration Record
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSystemConfiguration] (
	@ConfigKey varchar(100)
) AS 
BEGIN

	SELECT ConfigId, ConfigKey, ConfigValue, Description, DateCreated, DateUpdated FROM SystemConfiguration	WHERE ConfigKey = @ConfigKey

END



GO
