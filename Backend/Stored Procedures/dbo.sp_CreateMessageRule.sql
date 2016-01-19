SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh
-- Create date: 03/24/2015
-- Description: SP used to create / update Clinic Message Rules
-- Create date: 01/19/2016
-- Description: Inserting Dictators, JobTypes, Users to their respective child table instead on ClinicsMessagesRules table
CREATE PROCEDURE [dbo].[sp_CreateMessageRule]
(
	@MessageRuleId INT  = -1
	, @MessageTypeId INT = -1
	, @ClinicID SMALLINT = -1
	, @LocationID SMALLINT = -1
	, @DictatorID VARCHAR(MAX) = ''
	, @JobType VARCHAR(MAX) = ''
	, @StatJobSubjectPattern VARCHAR(4000) = ''
	, @StatJobContentPattern VARCHAR(4000) = ''
	, @NoStatJobSubjectPattern VARCHAR(4000) = ''
	, @NoStatJobContentPattern VARCHAR(4000) = ''
	, @SendTo VARCHAR(4000) = ''
	, @StatJobFrequency DECIMAL(8,2) = null
	, @NoStatJobFrequency DECIMAL(8,2) = null
	, @UserID VARCHAR(MAX) = ''
)
AS
BEGIN	
	IF NOT EXISTS(SELECT 1 FROM [ClinicsMessagesRules] WHERE [MessageRuleId] = @MessageRuleId)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
				DECLARE @CurrentMessageRuleId INT
				SET @CurrentMessageRuleId = (SELECT MAX(MessageRuleId)+1 FROM [ClinicsMessagesRules])

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
							(@CurrentMessageRuleId
							,@MessageTypeId
							,@ClinicID
							,@LocationID
							,''
							,''
							,@StatJobSubjectPattern
							,@StatJobContentPattern
							,@NoStatJobSubjectPattern
							,@NoStatJobContentPattern
							,@SendTo
							,@StatJobFrequency
							,@NoStatJobFrequency
							,NULL)
						
				INSERT INTO ClinicMessageRuleDictators
				SELECT @CurrentMessageRuleId, SplitData FROM DBO.fnSplitString(@DictatorID,',')

				INSERT INTO ClinicMessageRuleJobtypes
				SELECT @CurrentMessageRuleId, SplitData FROM DBO.fnSplitString(@JobType,',')

				INSERT INTO ClinicMessageRuleUsers
				SELECT @CurrentMessageRuleId, SplitData FROM DBO.fnSplitString(@UserID,',')
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
	ELSE
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
				UPDATE  [dbo].[ClinicsMessagesRules]
				SET 
					[MessageTypeId] = @MessageTypeId
					,[ClinicID] = @ClinicID
					,[LocationID] = @LocationID
					,[DictatorID] = ''
					,[JobType] = ''
					,[StatJobSubjectPattern] = @StatJobSubjectPattern
					,[StatJobContentPattern] = @StatJobContentPattern
					,[NoStatJobSubjectPattern] = @NoStatJobSubjectPattern
					,[NoStatJobContentPattern] = @NoStatJobContentPattern
					,[SendTo] = @SendTo
					,[StatJobFrequency] = @StatJobFrequency
					,[NoStatJobFrequency] = @NoStatJobFrequency
					,[UserID] = NULL
				WHERE [MessageRuleId] = @MessageRuleId

				DELETE FROM ClinicMessageRuleDictators WHERE MessageRuleId = @MessageRuleId
				DELETE FROM ClinicMessageRuleJobtypes WHERE MessageRuleId = @MessageRuleId
				DELETE FROM ClinicMessageRuleUsers WHERE MessageRuleId = @MessageRuleId

				INSERT INTO ClinicMessageRuleDictators
				SELECT @MessageRuleId, SplitData FROM DBO.fnSplitString(@DictatorID,',')

				INSERT INTO ClinicMessageRuleJobtypes
				SELECT @MessageRuleId, SplitData FROM DBO.fnSplitString(@JobType,',')

				INSERT INTO ClinicMessageRuleUsers
				SELECT @MessageRuleId, SplitData FROM DBO.fnSplitString(@UserID,',')
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 
			BEGIN
				ROLLBACK TRANSACTION
				DECLARE @ErrorMsg nvarchar(4000), @ErrorSeverity int
				SELECT @ErrorMsg = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY()
				RAISERROR(@ErrorMsg, @ErrorSeverity, 1)
			END
		END CATCH
		RETURN
	END
END
GO
