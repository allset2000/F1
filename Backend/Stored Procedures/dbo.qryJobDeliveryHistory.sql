SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobDeliveryHistory] (
   @JobNumber varchar(20)
) AS
	SELECT     DeliveredJobs.JobNumber, DeliveredJobs.Method, dbo.JobsDeliveryMethods.Description AS MethodName, DeliveredJobs.RuleName, 
			   DeliveredJobs.DeliveredOn
	FROM   (SELECT     JobNumber, Method, RuleName, DeliveredOn
		    FROM dbo.JobDeliveryHistory
		    WHERE (JobNumber = @JobNumber)
		      UNION
		    SELECT JobNumber, Method, RuleName, NULL AS DeliveredOn
		    FROM   dbo.JobsToDeliver
		    WHERE JobNumber = @JobNumber) AS DeliveredJobs 
	INNER JOIN dbo.JobsDeliveryMethods 
	ON DeliveredJobs.Method = dbo.JobsDeliveryMethods.JobDeliveryID
RETURN

GO
