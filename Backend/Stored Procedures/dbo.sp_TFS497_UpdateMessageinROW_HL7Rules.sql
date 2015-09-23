SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 9/23/15
-- Description: Temp SP used by Implementations to update the message in the ROW_HL7Rules table
-- TFS tickets are 412, 497, 498, 499, 590
-- =============================================

CREATE PROCEDURE [dbo].[sp_TFS497_UpdateMessageinROW_HL7Rules] 
@RuleID int,
@Message text

AS 

BEGIN
	
update ROW_Hl7Rules 
set Message = @Message
where RuleID = @RuleID
	
END

GO
