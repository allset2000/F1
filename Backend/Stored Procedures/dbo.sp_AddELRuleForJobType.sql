/****** Object:  StoredProcedure [dbo].[sp_AddELRuleForJobType]    Script Date: 8/17/2015 12:39:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/28/2015
-- Description: SP used to add Express Link Delivery Rule while Creating/Updating JobType
CREATE PROCEDURE [dbo].[sp_AddELRuleForJobType]
(
	@ClinicID INT,
	@JobType VARCHAR(50)
)
AS
BEGIN
	IF NOT EXISTS(SELECT RuleID FROM JobDeliveryRules WHERE ClinicID = @ClinicID AND JobType = @JobType AND Method = 900)
	BEGIN
		INSERT INTO JobDeliveryRules
		(ClinicID, JobType, Method)
		VALUES
		(@ClinicID, @JobType, 900)

		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 0
	END
END
GO


