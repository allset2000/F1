SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 6/4/2015
-- Description: SP used to pull  expresslink configuration from db 
-- =============================================
CREATE PROCEDURE [dbo].[GetConfigurationByClinicandEhr](
	@ClinicID as int,
	@EhrClinicID AS VARCHAR(50)
)
AS
BEGIN
	SELECT EL.*,C.ClinicCode 
	FROM ExpressLinkConfigurations EL INNER JOIN Clinics C on C.ClinicId = EL.ClinicId 
	WHERE EL.ClinicID = @ClinicID and EL.ehrclinicid= @EhrClinicID and EL.enabled = 1
END
GO
