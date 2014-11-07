SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/6/2014
-- Description: SP used to pull the rules reasons for Import screen
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRuleReasons] (
	 @ClinicId int,
	 @Type varchar(1)
) AS 
BEGIN
	SELECT ID,EHRCode,Description,Type FROM RulesReasons WHERE ClinicID = @ClinicId and Type = @Type
END


GO
