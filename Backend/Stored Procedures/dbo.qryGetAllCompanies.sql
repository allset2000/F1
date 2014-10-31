SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/30/2014
-- Description: SP used to get all Companies to dispaly on the Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[qryGetAllCompanies]  AS 
BEGIN
	
	SELECT CompanyId, CompanyName, CompanyCode, EditingWorkflowModelId, CompanyStatus FROM Companies
		
END


GO
