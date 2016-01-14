SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Narender 
-- Create date: 14 Jan 2016
-- Description: This proc returns JobTypes for selected clinic
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobTypesByClinicID] (
	@clinicId int
) AS
BEGIN
	SELECT * FROM JobTypes WHERE ClinicID = @clinicId AND Deleted = 0
END
