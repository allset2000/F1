SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Narender
-- Create date: 10/31/2014
-- Description: SP used to fetch Documents for Archived Job used in Portal
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetArchivedJobDocument]
	 @JubNumber varchar(20)
AS
BEGIN
	SELECT * FROM dbo.Jobs_Documents WHERE JobNumber = @JubNumber
END
GO
