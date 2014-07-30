SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[qryQueryParametersCount](@SysObjName nvarchar ( 64 ))
	RETURNS TABLE
AS
RETURN(	
	SELECT MPTQueryParameters.QueryName, 
	Count(MPTQueryParameters.ParameterName) AS ParameterCount
	FROM MPTQueryParameters
	WHERE MPTQueryParameters.QueryName=@SysObjName
	GROUP BY MPTQueryParameters.QueryName
	)
GO
