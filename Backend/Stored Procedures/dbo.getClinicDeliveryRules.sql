SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getClinicDeliveryRules] (
   @ClinicId int
) AS
	SELECT dbo.JobDeliveryRules.*, JobsDeliveryMethods.Description AS MethodName
	FROM   dbo.JobDeliveryRules INNER JOIN dbo.JobsDeliveryMethods
	ON JobDeliveryRules.Method = JobsDeliveryMethods.JobDeliveryID	
	WHERE (dbo.JobDeliveryRules.ClinicID = @ClinicId)
RETURN
GO
