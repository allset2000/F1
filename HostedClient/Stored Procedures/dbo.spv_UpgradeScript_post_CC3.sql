SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/3/2014
-- Description: SP Used to store all data changes in the CC.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC3]
AS
BEGIN

--BEGIN #3398# - Change user permission for dictator management
if not exists(select * from Permissions where Code = 'FNC-DICTATOR-CHANGEUSER')
	BEGIN
		INSERT INTO Permissions(code,name,parentpermissionid,moduleid) values('FNC-DICTATOR-CHANGEUSER','Function - Change Dictator User',null,4)
	END
--END #3398# - change user permission for dictator management

END
GO
