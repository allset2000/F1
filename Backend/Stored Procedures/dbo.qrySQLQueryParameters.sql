SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qrySQLQueryParameters] 
	@SysObjectName nvarchar(64)
AS
BEGIN
SELECT '@' + MPTQueryParameters.ParameterName AS [Name], MPTQueryParameters.ParameterSqlType, MPTQueryParameters.ParameterDirection,
       MPTQueryParameters.ParameterSize, MPTQueryParameters.ParameterScale, MPTQueryParameters.ParameterPrecision, 
       MPTQueryParameters.ParameterDefaultValue, qryQueryParametersCount.ParameterCount
FROM   MPTQueryParameters INNER JOIN
       dbo.qryQueryParametersCount(@SysObjectName) AS qryQueryParametersCount ON 
       MPTQueryParameters.QueryName = qryQueryParametersCount.QueryName
WHERE  MPTQueryParameters.QueryName = @SysObjectName
ORDER BY MPTQueryParameters.ParameterIndex
END



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
