SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getClinic] (
   @ClinicId int
) AS
	SELECT *
	FROM   dbo.vwClinics
  WHERE (ClinicId = @ClinicId)
RETURN



GO
