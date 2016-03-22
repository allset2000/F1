
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Installation Note: This is a pre-installation script, this procedure should be executed before taking the latest schema
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_E2_PreProcess] 
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_E2_PreProcess
--X
--X AUTHOR: Sharif Shaik
--X
--X DESCRIPTION: This script updates/deletes the data to enable the constraints to be deployed without any issues.
--X				 This is a pre-installation script, this procedure should be executed before taking the latest schema
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket #
--X_____________________________________________________________________________
--X   0    | 11-Jan-2016  | Sharif Shaik			| Initial Design

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX		
AS
BEGIN

	SET NOCOUNT ON;

	
END  -- End of Proc
GO
