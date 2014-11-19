SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================  
-- Author: Santhosh 
-- Create date: 10/31/2014  
-- Description: SP used to get Company details to display on the Admin Console  
-- =============================================  
CREATE PROCEDURE [dbo].[getCompanyByID] 
(  
   @CompanyID VARCHAR(10)
) 
AS  
BEGIN
	SELECT 
		CompanyId
		, CompanyName
		, CompanyCode
		, EditingWorkflowModelId
		, CompanyStatus 
	FROM Companies  	
	WHERE CompanyId = @CompanyID
END
GO
