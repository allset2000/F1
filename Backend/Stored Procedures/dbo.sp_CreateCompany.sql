SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================    
-- Author: Santhosh   
-- Create date: 10/31/2014    
-- Description: SP used to Create new Company which we display on the Admin Console    
-- =============================================    
CREATE PROCEDURE [dbo].[sp_CreateCompany] 
(       
   @CompanyName VARCHAR(60) = ''  
   , @CompanyCode VARCHAR(16) = ''  
   , @EditingWorkflowModelId INT = 0  
   , @CompanyStatus CHAR = ''     
)   
AS    
BEGIN  
 INSERT INTO Companies   
 (  
	CompanyId
	, CompanyName  
	, CompanyCode  
	, EditingWorkflowModelId  
	, CompanyStatus  
 )  
 VALUES  
 (  
	(SELECT MAX(CompanyID)+1 FROM Companies)
	, @CompanyName  
	, @CompanyCode  
	, @EditingWorkflowModelId  
	, @CompanyStatus  
 )  
 SELECT SCOPE_IDENTITY()
END  
  
  
GO
