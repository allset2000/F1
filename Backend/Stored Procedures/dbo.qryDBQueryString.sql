SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[qryDBQueryString] (
	@QueryName [varchar] (64)
) AS
	SELECT *
	FROM  DBQueryStrings
	WHERE (QueryName = @QueryName)
	
RETURN
GO
