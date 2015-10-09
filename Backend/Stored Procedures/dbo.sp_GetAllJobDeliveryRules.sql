/****** Object:  StoredProcedure [dbo].[sp_GetAllJobDeliveryRules]    Script Date: 10/8/2015 1:53:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to get Job Delivery Rules to display on the Admin Console  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetAllJobDeliveryRules]
AS
BEGIN
	SELECT 
		D.RuleID AS 'DeliveryRuleID'
		, D.ClinicID AS 'RuleClinicID'
		, ISNULL(D.LocationID,0) AS 'RuleLocationID'
		, ISNULL(D.DictatorName,'') AS 'RuleDictator'
		, ISNULL(D.JobType,'') AS JobType
		, D.Method
		, (CASE WHEN D.Method = 1100 THEN 'Image'
							WHEN D.Method = 100 THEN 'Full Document'
							WHEN D.Method = 300 THEN 'NextGen Doc'
							WHEN D.Method = 600 THEN 'NextGen Note'
							WHEN D.Method = 400 THEN 'NextGenDD'
							WHEN D.Method = 1000 THEN 'NextGen Image'
							WHEN D.Method = 200 THEN 'HL7'
							WHEN D.Method = 900 THEN 'EL Hosted(900)'
							WHEN D.Method = 0 THEN 'No Delivery' END) AS 'MethodName'
		, D.RuleName AS 'DeliveryRuleName'
		, D.AvoidRedelivery
		, C.ClinicName
		, ISNULL(L.LocationName,'') AS LocationName
	FROM JobDeliveryRules D
	INNER JOIN Clinics C ON C.ClinicID = D.ClinicID
	LEFT JOIN Locations L ON L.LocationID = ISNULL(D.LocationID,0) AND L.ClinicID = D.ClinicID
	ORDER BY D.RuleID DESC
END

GO


