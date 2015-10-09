/****** Object:  StoredProcedure [dbo].[sp_InsertJobDeliveryRule]    Script Date: 10/8/2015 2:13:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to insert Job Delivery Rules and to respective table based on method value
-- =============================================  
CREATE PROCEDURE [dbo].[sp_InsertJobDeliveryRule] 
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
)
AS
BEGIN
	IF(@RuleID = -1)
	BEGIN		
		INSERT INTO JobDeliveryRules 
		(ClinicID, LocationID, DictatorName, JobType, Method, RuleName, AvoidRedelivery)
		VALUES
		(@ClinicID, @LocationID, @DictatorName, @JobType, @Method, @RuleName, @AvoidRedelivery)
	END
	ELSE
	BEGIN
		UPDATE JobDeliveryRules
		SET RuleName = @RuleName, AvoidRedelivery = @AvoidRedelivery
		WHERE RuleID = @RuleID

		IF @Method = 1100
		BEGIN		
			INSERT INTO ROW_ImageRules VALUES (@ClinicID, @LocationID, @DictatorName, @RenamingRule, @RuleName)			
		END
		ELSE IF @Method = 100
		BEGIN
			INSERT INTO ROW_DocumentRules VALUES (@ClinicID, @LocationID, @DictatorName, @RenamingRule, @RuleName)			
		END
		ELSE IF @Method = 300
		BEGIN
			INSERT INTO ROW_NextGenDoc VALUES (@ClinicID, @LocationID, @DictatorName, @FieldData, @RuleName)			
		END
		ELSE IF @Method = 600
		BEGIN
			INSERT INTO ROW_NextGenNote VALUES (@ClinicID, @LocationID, @DictatorName, @FieldData, @RuleName)			
		END
		ELSE IF @Method = 400
		BEGIN
			INSERT INTO ROW_NextGenDD VALUES (@ClinicID, @LocationID, @DictatorName, @FieldData, @RuleName)			
		END
		ELSE IF @Method = 1000
		BEGIN
			INSERT INTO ROW_NextGenImage VALUES (@ClinicID, @LocationID, @DictatorName, @FieldData, @RuleName)			
		END
		ELSE IF @Method = 200
		BEGIN
			INSERT INTO ROW_HL7Rules VALUES (@ClinicID, @LocationID, @DictatorName, @Message, @FieldData, @RuleName)			
		END

	END
END



GO


