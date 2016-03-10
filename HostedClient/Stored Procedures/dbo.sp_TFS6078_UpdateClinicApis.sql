SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 2/10/16
-- Description: Temp SP used update the connection string in ClinicApis. TFS ticket 6078
-- =============================================

CREATE PROCEDURE [dbo].[sp_TFS6078_UpdateClinicApis] 

@ClinicID smallint,
@ConnectionString Varchar(MAX)

AS 

UPDATE Entradahostedclient.dbo.ClinicApis
SET ConnectionString = @ConnectionString
WHERE ClinicID = @ClinicID


GO
