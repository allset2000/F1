SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[getRequestQuery]	
(
@queryId int
)	
AS
SELECT     QueryName, SortField, KeyField, FieldsToDisplay, FieldToExclude
FROM         MPTRequestQuery
WHERE     (QueryId = @queryId)
RETURN

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
