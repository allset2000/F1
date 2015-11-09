
/****** Object:  StoredProcedure [dbo].[sp_CheckJobDeliveryRule]    Script Date: 8/17/2015 12:44:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to check Job Delivery Rule already exists or not
-- =============================================  
CREATE PROCEDURE [dbo].[sp_CheckJobDeliveryRule] 
(
	@ClinicID INT 	
	, @DictatorName VARCHAR(50)	
	, @Method INT
	, @Jobtype VARCHAR(50)	
	, @LocationID INT
)
AS
BEGIN
	SELECT 
		J.RuleID AS DeliveryRuleID
		, J.ClinicID AS RuleClinicID
		, J.LocationID AS RuleLocationID
		, J.DictatorName AS RuleDictator
		, J.JobType
		, J.Method
		, J.RuleName AS DeliveryRuleName
		, J.AvoidRedelivery
	FROM JobDeliveryRules J
	WHERE 
	J.ClinicID = @ClinicID
	AND J.Method = @Method
	AND ISNULL(J.JobType,'') = @Jobtype
	AND ISNULL(J.LocationID,0) =  @LocationID
	AND ISNULL(J.DictatorName,'') = @DictatorName
END


GO


