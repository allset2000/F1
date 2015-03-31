SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 03/20/2015
-- Description: SP Used to update the JobProcessFailureCount in jobs table
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateJobProcessFailureCount]
 @jobNumber VARCHAR(20)
 AS
BEGIN
 declare @ProcessFailureCount smallint

 IF(( select ProcessFailureCount from Jobs where JobNumber = @jobNumber) is NOT NULL)
		UPDATE Jobs SET @ProcessFailureCount = ProcessFailureCount = ProcessFailureCount + 1 WHERE (JobNumber = @jobNumber)
 ELSE
		UPDATE Jobs SET  ProcessFailureCount = 1 WHERE (JobNumber = @jobNumber)
END

GO


