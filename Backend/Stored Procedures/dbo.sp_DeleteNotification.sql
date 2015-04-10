-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to delete clinic message rule
CREATE PROCEDURE [dbo].[sp_DeleteNotification]
(
	@MessageRuleID INT
)
AS
BEGIN
	DELETE FROM ClinicsMessagesRules WHERE MessageRuleID = @MessageRuleID
	SELECT 1
END


GO


