
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/4/2014
-- Description: SP Used to store all data changes in the CC.1 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC1]
AS
BEGIN
--BEGIN #2534#
--Sam 12/4/2014
if not exists(select * from Permissions where Code = 'FNC-RULES-ADDSCHEDULE')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-RULES-ADDSCHEDULE','Function - Add Schedule based job building rule')
	END
if not exists(select * from Permissions where Code = 'FNC-RULES-ADDORDER')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-RULES-ADDORDER','Function - Add Order based job building rule')
	END
if not exists(select * from Permissions where Code = 'FNC-RULES-UPDATE')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-RULES-UPDATE','Function - Edit job building rules')
	END
--END #2534#
--BEGIN #0000# - Entrada/Athena Hackathon item added
if not exists(select * from Permissions where Code = 'TAB-API-SCRATCHPAD')
	BEGIN
		INSERT INTO permissions(code,name) VALUES('TAB-API-SCRATCHPAD','TAB - DEV API ScrathcPAd')
	END
END
GO
