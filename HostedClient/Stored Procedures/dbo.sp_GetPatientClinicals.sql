SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 5/11/2015
-- Description: SP used to pull patient clinical data from the db
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPatientClinicals] (
	@PatientId int
) AS 
BEGIN
	SELECT * FROM PatientClinicals WHERE PatientID = @PatientId and Data is not null and LEN(Data) > 0
END


GO
