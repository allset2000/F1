SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 5/20/2015
-- Description: SP Used to store all data changes in the D.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_D2]
AS
BEGIN
-- #3768# - Adding Timezone lookup table values
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='WST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('WST')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='MNT') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('MNT')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='CST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('CST')
END
IF NOT EXISTS (SELECT 1 FROM dbo.TimeZone WHERE TimeZoneName='EST') BEGIN
	INSERT INTO TimeZone(TimeZoneName) values('EST')
END
-- #3768# - End of adds
END
GO
