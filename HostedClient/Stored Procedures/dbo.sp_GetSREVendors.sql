CREATE PROCEDURE [dbo].[sp_GetSREVendors]
AS
BEGIN
	SELECT
		SreTypeId
		, SreType
	FROM
    SreEngineType	
END

GO


