USE [Entrada_Archive]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetArchivedJobDocument]    Script Date: 11/07/2014 00:17:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

