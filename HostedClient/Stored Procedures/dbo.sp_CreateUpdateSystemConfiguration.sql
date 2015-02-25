SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/24/2015
-- Description: SP used to Create / Update System Configuration Records
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateSystemConfiguration] (
	@ConfigKey varchar(100),
	@ConfigValue varchar(100),
	@Description varchar(1000)
) AS 
BEGIN
	
	IF NOT EXISTS(SELECT 1 FROM SystemConfiguration WHERE ConfigKey = @ConfigKey)
	BEGIN
		INSERT INTO SystemConfiguration(ConfigKey, ConfigValue, Description, DateCreated, DateUpdated)
		VALUES(@ConfigKey, @ConfigValue, @Description, GETDATE(), GETDATE())
	END
	ELSE
	BEGIN
		UPDATE SystemConfiguration SET ConfigValue = @ConfigValue, Description = @Description, DateUpdated = GETDATE() WHERE ConfigKey = @ConfigKey
	END
END



GO
