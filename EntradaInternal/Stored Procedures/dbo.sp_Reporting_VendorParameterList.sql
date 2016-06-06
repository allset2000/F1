SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_Reporting_VendorParameterList]

AS

SELECT 
      CompanyName
      ,CompanyCode

  FROM Entrada.dbo.DSGCompanies
  WHERE CompanyCode in ('EHS','MAP','PRO','MTP','SCR','PTI','ENT')
  Order by CompanyName asc
  
  
GO
