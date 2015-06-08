SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 05/26/2015
-- Description: SP Used to Get the Clinics based on User Role
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetClinicsByUserId]
@userId varchar(50)
AS
BEGIN
-- It requires User Role, so that we can get the Clinics based on the user role. will update once we have roles created
	SELECT * FROM Clinics
END

GO


