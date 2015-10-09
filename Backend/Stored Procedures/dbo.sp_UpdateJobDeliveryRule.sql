/****** Object:  StoredProcedure [dbo].[sp_UpdateJobDeliveryRule]    Script Date: 10/8/2015 4:35:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to update Job Delivery Rules and to respective table based on method value
-- =============================================  
CREATE PROCEDURE [dbo].[sp_UpdateJobDeliveryRule] 
(
	@ClinicID INT 
	, @LocationID INT 
	, @DictatorName VARCHAR(50)
	, @JobType VARCHAR(100)
	, @Method INT
	, @RuleName VARCHAR(50)
	, @AvoidRedelivery BIT
	, @RenamingRule VARCHAR(MAX)
	, @FieldData VARCHAR(MAX)
	, @Message VARCHAR(MAX)
	, @RuleID INT
	, @RuleTypeID INT
)
AS
BEGIN	
	IF(@RuleTypeID = -1)
	BEGIN
		-- Updating Job Delivery Rules table only			
		UPDATE JobDeliveryRules
		SET ClinicID = @ClinicID
			, LocationID = @LocationID
			, DictatorName = @DictatorName
			, JobType = @JobType
			, Method = @Method
			, RuleName = @RuleName
			, AvoidRedelivery = @AvoidRedelivery
		WHERE RuleID = @RuleID
	END
	ELSE
	BEGIN
		-- Updating Child Rules table along with JobDEliveryRules table
		Update JobDeliveryRules
		SET RuleName = @RuleName, AvoidRedelivery = @AvoidRedelivery
		WHERE RuleID = @RuleID

		IF @Method = 1100
		BEGIN		
			UPDATE ROW_ImageRules SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, RenamingRule = @RenamingRule, RuleName = @RuleName WHERE RuleId = @RuleTypeID
		END
		ELSE IF @Method = 100
		BEGIN
			UPDATE ROW_DocumentRules SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, RenamingRule = @RenamingRule, RuleName = @RuleName WHERE RuleId = @RuleTypeID			
		END
		ELSE IF @Method = 300
		BEGIN
			UPDATE ROW_NextGenDoc SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, FieldData = @FieldData, RuleName = @RuleName WHERE RuleId = @RuleTypeID			
		END
		ELSE IF @Method = 600
		BEGIN
			UPDATE ROW_NextGenNote SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, FieldData = @FieldData, RuleName = @RuleName WHERE RuleId = @RuleTypeID						
		END
		ELSE IF @Method = 400
		BEGIN
			UPDATE ROW_NextGenDD SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, FieldData = @FieldData, RuleName = @RuleName WHERE RuleId = @RuleTypeID						
		END
		ELSE IF @Method = 1000
		BEGIN
			UPDATE ROW_NextGenImage SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, FieldData = @FieldData, RuleName = @RuleName WHERE RuleId = @RuleTypeID						
		END
		ELSE IF @Method = 200
		BEGIN
			UPDATE ROW_HL7Rules SET ClinicID = @ClinicID, LocationID = @LocationID, DictatorName = @DictatorName, Message = @Message, FieldData = @FieldData, RuleName = @RuleName WHERE RuleId = @RuleTypeID						
		END

	END
END



GO


