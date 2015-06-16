SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 6/15/15
-- Description: Temp SP used to update FieldData in the ROW_NextGenDoc Table
-- See also RM 4721
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM1939_ROW_NextGenDoc_UpdateFieldData] 
(
@RuleID int,
@FieldData text 
) 

AS 

BEGIN
	
update ROW_NextGenDoc set FieldData = @FieldData where RuleID = @RuleID
	
END


GO
