SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/12/2014
-- Description: SP Used to store all data changes in the CC.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC2]
AS
BEGIN

--BEGIN #0000# - Fixing Spelling
if exists(select * from Permissions where Code = 'TAB-API-SCRATCHPAD')
	BEGIN
		UPDATE Permissions set name = 'TAB - DEV API ScratchPad' where code = 'TAB-API-SCRATCHPAD'
	END
--END #0000# - Fixing Spelling

END
GO
