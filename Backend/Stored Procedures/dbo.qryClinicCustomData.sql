SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[qryClinicCustomData] (
   @ClinicID smallint
) AS
	SELECT [Field], [Description]
	FROM   dbo.Clinics_CustomData
    WHERE (ClinicID = @ClinicID)
RETURN
GO
