SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryAvailableSignersRules] (
	@ReviewDictatorID varchar(50)
)
AS
  SELECT *
  FROM   dbo.vwDocumentSignersRules
  WHERE (ReviewDictatorID = @ReviewDictatorID)
RETURN
GO
