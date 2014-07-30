SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getQASubCategories]
AS
	SELECT OldCategoryID AS CategoryID, OldSubCategoryID AS SubCategoryID, QACategory AS Description 
	FROM vwQACategories
	WHERE (ParentId <> -1)
RETURN
GO
