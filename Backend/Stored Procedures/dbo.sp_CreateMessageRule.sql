-- =============================================
-- Author: Santhosh
-- Create date: 03/24/2015
-- Description: SP used to create Clinic Message Rules
CREATE PROCEDURE [dbo].[sp_CreateMessageRule]
(
	@MessageRuleId INT  = -1
	, @MessageTypeId INT = -1
	, @ClinicID SMALLINT = -1
	, @LocationID SMALLINT = -1
	, @DictatorID VARCHAR(50) = ''
	, @JobType VARCHAR(50) = ''
	, @StatJobSubjectPattern VARCHAR(4000) = ''
	, @StatJobContentPattern VARCHAR(4000) = ''
	, @NoStatJobSubjectPattern VARCHAR(4000) = ''
	, @NoStatJobContentPattern VARCHAR(4000) = ''
	, @SendTo VARCHAR(4000) = ''
	, @StatJobFrequency DECIMAL(8,2) = null
	, @NoStatJobFrequency DECIMAL(8,2) = null
	, @UserID INT = -1
)
AS
BEGIN	
	IF NOT EXISTS(SELECT 1 FROM [ClinicsMessagesRules] WHERE [MessageRuleId] = @MessageRuleId)
	BEGIN
	INSERT INTO [dbo].[ClinicsMessagesRules]
				([MessageRuleId]
				,[MessageTypeId]
				,[ClinicID]
				,[LocationID]
				,[DictatorID]
				,[JobType]
				,[StatJobSubjectPattern]
				,[StatJobContentPattern]
				,[NoStatJobSubjectPattern]
				,[NoStatJobContentPattern]
				,[SendTo]
				,[StatJobFrequency]
				,[NoStatJobFrequency]
				,[UserID])
			VALUES
				((SELECT MAX(MessageRuleId)+1 FROM [ClinicsMessagesRules])
				,@MessageTypeId
				,@ClinicID
				,@LocationID
				,@DictatorID
				,@JobType
				,@StatJobSubjectPattern
				,@StatJobContentPattern
				,@NoStatJobSubjectPattern
				,@NoStatJobContentPattern
				,@SendTo
				,@StatJobFrequency
				,@NoStatJobFrequency
				,@UserID)
	SELECT SCOPE_IDENTITY()		
	END
	ELSE
	BEGIN
		UPDATE  [dbo].[ClinicsMessagesRules]
		SET 
			[MessageTypeId] = @MessageTypeId
			,[ClinicID] = @ClinicID
			,[LocationID] = @LocationID
			,[DictatorID] = @DictatorID
			,[JobType] = @JobType
			,[StatJobSubjectPattern] = @StatJobSubjectPattern
			,[StatJobContentPattern] = @StatJobContentPattern
			,[NoStatJobSubjectPattern] = @NoStatJobSubjectPattern
			,[NoStatJobContentPattern] = @NoStatJobContentPattern
			,[SendTo] = @SendTo
			,[StatJobFrequency] = @StatJobFrequency
			,[NoStatJobFrequency] = @NoStatJobFrequency
			,[UserID] = @UserID
		WHERE [MessageRuleId] = @MessageRuleId
	END
END
GO


