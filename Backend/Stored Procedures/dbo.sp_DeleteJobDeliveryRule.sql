/****** Object:  StoredProcedure [dbo].[sp_DeleteJobDeliveryRule]    Script Date: 8/19/2015 3:30:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to delete Job Delivery Rule and from respective table
-- =============================================  
CREATE PROCEDURE [dbo].[sp_DeleteJobDeliveryRule] 
(
	@RuleId INT
)
AS
BEGIN
	DELETE FROM JobDeliveryRules WHERE RuleID = @RuleId
	SELECT 1
END
GO


