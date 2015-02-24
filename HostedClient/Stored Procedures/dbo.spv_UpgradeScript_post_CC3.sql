
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
-- #0000# - Added perm for adding dictator
if not exists(select * from Permissions where Code = 'FNC-DICTATORS-ADD')
	BEGIN
		INSERT INTO Permissions(Code,Name,ModuleId) VALUES('FNC-DICTATORS-ADD','Function - Add New Dictators',4)
	END
-- #0000# - Added perm for adding dictator
--BEGIN #3402# - Add / Remove Role from all dictators for client
if not exists(select * from Permissions where Code = 'FNC-DICTATORS-ADDMASSROLE')
	BEGIN
		INSERT INTO Permissions(Code,Name,ModuleId) VALUES('FNC-DICTATORS-ADDMASSROLE','Function - Manage Dictator Roles (Mass)',4)
	END
--END #3402# - Add / Remove Role from all dictators for client
END
GO
