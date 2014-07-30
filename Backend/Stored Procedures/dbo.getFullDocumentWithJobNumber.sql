SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getFullDocumentWithJobNumber] (
   @JobNumber varchar(20)
)
AS
  SELECT *
  FROM   dbo.vwDocuments
  WHERE (JobNumber = @JobNumber);
RETURN
GO
