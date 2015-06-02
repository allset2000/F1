SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 05/25/2015
-- Description: SP Used to Get the Dictators based on Clinic
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetDictatorsByClinicId]
(
 @clinicId SMALLINT
)
AS
BEGIN
	SELECT * FROM Dictators WHERE ClinicId = @clinicId
END

GO


