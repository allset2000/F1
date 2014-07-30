SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getClinicLastRuleMessage] (
   @MessageRuleId int
) AS
	SELECT TOP(1) *
	FROM   dbo.ClinicsMessages
  WHERE (MessageRuleId = @MessageRuleId) AND (MessageStatus = 'S')
  ORDER BY SendTime DESC, MessageId DESC
RETURN
GO
