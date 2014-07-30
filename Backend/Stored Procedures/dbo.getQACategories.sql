SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getQACategories]
AS
	SELECT OldCategoryId AS CategoryID, QACategory AS Description
	FROM   dbo.vwQACategories
	WHERE (OldCategoryId <> -1) AND (OldSubcategoryId = -1)
RETURN
GO
