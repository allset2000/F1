
/****** Object:  StoredProcedure [dbo].[sp_InsertJobDeliveryRule]    Script Date: 8/19/2015 3:41:48 AM ******/
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

		DECLARE @Tbl VARCHAR(30)
		DECLARE @Value VARCHAR(MAX)
		DECLARE @Sql VARCHAR(MAX)

		SET @Tbl = (SELECT (CASE WHEN @Method = 1100 THEN 'ROW_ImageRules'
								WHEN @Method = 100 THEN 'ROW_DocumentRules'
								WHEN @Method = 300 THEN 'ROW_NextGenDoc'
								WHEN @Method = 600 THEN 'ROW_NextGenNote'
								WHEN @Method = 400 THEN 'ROW_NextGenDD'
								WHEN @Method = 1000 THEN 'ROW_NextGenImage'
								WHEN @Method = 200 THEN 'ROW_HL7Rules' END))

		SET @Value = (SELECT (CASE WHEN CHARINDEX('Nextgen', @Tbl) > 0 THEN '('+CONVERT(VARCHAR,@ClinicID)+','+CONVERT(VARCHAR,@LocationID)+','''+@DictatorName+''','''+@FieldData+''','''+@RuleName+''')'
						WHEN (@Tbl = 'ROW_ImageRules' OR @Tbl = 'ROW_DocumentRules') THEN '('+CONVERT(VARCHAR,@ClinicID)+','+CONVERT(VARCHAR,@LocationID)+','''+@DictatorName+''','''+@RenamingRule+''','''+@RuleName+''')'
						WHEN @Tbl = 'ROW_HL7Rules' THEN '('+CONVERT(VARCHAR,@ClinicID)+','+CONVERT(VARCHAR,@LocationID)+','''+@DictatorName+''','''+@Message+''','''+@FieldData+''','''+@RuleName+''')' END))

		SET @Sql = 'INSERT INTO ' + @Tbl + ' VALUES ' + @Value
		EXECUTE(@Sql)
	END
END



GO


