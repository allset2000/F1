SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryDBPostgreSqlQueryParameters]
(
	@QueryName 	[varchar] (64)
)
AS
	SELECT '@' + Parameters.ParameterName AS [Name], ParameterSqlType, 
		   ParameterDirection, ParameterSize, ParameterScale, ParameterPrecision,
	       ParameterDefaultValue, ParametersCounter.ParameterCount, ParameterIndex FROM 
	
	(	SELECT QueryName, COUNT(ParameterIndex) AS ParameterCount	
		FROM   DBQueryParameters
		WHERE (QueryName = @QueryName)
		GROUP BY QueryName
	)  ParametersCounter
	
	INNER JOIN
	
	(
		SELECT ParameterName, ParameterSqlType, ParameterDirection, 
			   ParameterSize, ParameterScale, ParameterPrecision,
			   ParameterDefaultValue, ParameterIndex, QueryName
		FROM DBQueryParameters
		WHERE (QueryName = @QueryName)
	) Parameters
	
	ON ParametersCounter.QueryName = Parameters.QueryName
	
RETURN

GO
