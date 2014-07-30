SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryDictatorMacros] (
   @DictatorID varchar(50)
) AS
	SELECT [Name], [Text]
	FROM   dbo.Macros
    WHERE (DictatorID = @DictatorID)
RETURN
GO
