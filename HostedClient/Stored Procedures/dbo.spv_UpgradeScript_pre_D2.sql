SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Vivek
-- Create date: 9/29/2015
-- Description: SP Used to store all data changes in the D.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_pre_D2]
AS
BEGIN

--clean up orphan records as we're setting FK on roles.clinicid
delete from roles where clinicid not in (select clinicid from clinics)
--clean up orphan records as we're setting FK xref.roleid
delete from RoleApplicationXref where roleid not in (select roleid from roles)

END


GO
