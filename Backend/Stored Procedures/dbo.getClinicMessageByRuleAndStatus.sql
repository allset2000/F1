SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getClinicMessageByRuleAndStatus] (
   @MessageRuleId int,
   @MessageStatus char(1)
) AS
	SELECT *
	FROM   dbo.ClinicsMessages
  WHERE (MessageRuleId = @MessageRuleId) AND (MessageStatus = @MessageStatus)
RETURN
GO
