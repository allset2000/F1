/****** Object:  StoredProcedure [dbo].[sp_GetJobDeliveryRule]    Script Date: 10/8/2015 5:12:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to get Job Delivery Rule from respective table
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetJobDeliveryRule] 
(
	@RuleID INT	
)
AS
BEGIN
	DECLARE @Tbl VARCHAR(30)
	DECLARE @Value VARCHAR(MAX)
	DECLARE @Sql VARCHAR(MAX)		
	DECLARE @Method INT
		
	SELECT  @Method = Method			
	FROM JobDeliveryRules WHERE RuleID = @RuleID

	-- As there is no configuration data for EL Hosted (900) and No Delivery, Directly pulling data from JobDeliveryRules table
	IF(@Method = 900 OR CONVERT(VARCHAR,@Method) = '0')
	BEGIN
		SELECT
			J.RuleID AS DeliveryRuleID, 
			J.ClinicID AS RuleClinicID, 
			J.LocationID AS RuleLocationID, 
			J.DictatorName AS RuleDictator, 
			J.JobType, 
			J.Method, 
			J.RuleName AS DeliveryRuleName,
			J.AvoidRedelivery
		FROM JobDeliveryRules J
		WHERE RuleID = @RuleID
	END
	ELSE
	BEGIN
		SET @Tbl = (SELECT (CASE WHEN @Method = 1100 THEN 'ROW_ImageRules'
								WHEN @Method = 100 THEN 'ROW_DocumentRules'
								WHEN @Method = 300 THEN 'ROW_NextGenDoc'
								WHEN @Method = 600 THEN 'ROW_NextGenNote'
								WHEN @Method = 400 THEN 'ROW_NextGenDD'
								WHEN @Method = 1000 THEN 'ROW_NextGenImage'
								WHEN @Method = 200 THEN 'ROW_HL7Rules' END))	

		SET @Value = (SELECT (CASE WHEN CHARINDEX('Nextgen', @Tbl) > 0 THEN 'J.AvoidRedelivery, J.RuleID AS DeliveryRuleID, J.ClinicID AS RuleClinicID, ISNULL(J.LocationID,''0'') AS RuleLocationID, J.DictatorName AS RuleDictator, J.JobType, J.Method, J.RuleName AS DeliveryRuleName, R.RuleId AS RuleTypeId, R.FieldData, ''0'' AS RenamingRule'
							WHEN (@Tbl = 'ROW_ImageRules' OR @Tbl = 'ROW_DocumentRules') THEN 'J.AvoidRedelivery, J.RuleID AS DeliveryRuleID, J.ClinicID AS RuleClinicID, ISNULL(J.LocationID,''0'') AS RuleLocationID, J.DictatorName AS RuleDictator, J.JobType, J.Method, J.RuleName AS DeliveryRuleName, R.RuleId AS RuleTypeId, ''0'' AS FieldData, R.RenamingRule'
							WHEN @Tbl = 'ROW_HL7Rules' THEN 'J.AvoidRedelivery, J.RuleID AS DeliveryRuleID, J.ClinicID AS RuleClinicID, ISNULL(J.LocationID,''0'') AS RuleLocationID, J.DictatorName AS RuleDictator, J.JobType, J.Method, J.RuleName AS DeliveryRuleName, R.RuleId AS RuleTypeId, R.FieldData, ''0'' AS RenamingRule, R.Message' END))

		SET @Sql = 'SELECT ' + @Value + ' FROM JobDeliveryRules J LEFT JOIN ' + @Tbl + ' R
					ON R.ClinicID = J.ClinicID
					AND ISNULL(R.DictatorName,'''') = ISNULL(J.DictatorName,'''') 
					AND ISNULL(R.RuleName,'''') = ISNULL(J.RuleName,'''')
					AND ISNULL(R.LocationID,''0'') = ISNULL(J.LocationID,''0'')
					WHERE J.RuleId = ' + CONVERT(VARCHAR,@RuleID) + ''
		--PRINT @Sql
		EXECUTE(@Sql)
	END
END


GO


