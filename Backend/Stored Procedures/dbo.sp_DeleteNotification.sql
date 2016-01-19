SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to delete clinic message rule
-- Modified date: 01/19/2016
-- Description: Deleting records from child tables also along with parent table
CREATE PROCEDURE [dbo].[sp_DeleteNotification]
(
	@MessageRuleID INT
)
AS
BEGIN	
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM dbo.ClinicMessageRuleDictators WHERE MessageRuleId = @MessageRuleID
			DELETE FROM dbo.ClinicMessageRuleJobtypes WHERE MessageRuleId = @MessageRuleID
			DELETE FROM dbo.ClinicMessageRuleUsers WHERE MessageRuleId = @MessageRuleID
			DELETE FROM dbo.ClinicsMessages WHERE MessageRuleID = @MessageRuleID
			DELETE FROM dbo.ClinicsMessagesRules WHERE MessageRuleID = @MessageRuleID	
			SELECT 1
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		BEGIN
			ROLLBACK TRANSACTION
			DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END
	END CATCH
	RETURN	
END

GO
