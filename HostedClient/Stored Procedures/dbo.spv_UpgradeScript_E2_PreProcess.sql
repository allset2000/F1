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
--X DESCRIPTION: This script updateds/deletes the data to enable the constraints to be deployed without any issues.
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
--X   1    | 11-Jan-2016  | Sharif Shaik			| #4459 - Adding New column to Applications and Module table

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX		
AS
BEGIN

	SET NOCOUNT ON;
	
	/* BEGIN - #4459 - Adding New column to Applications and Module table */
		IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS		
					WHERE TABLE_NAME = 'Applications'
					AND COLUMN_NAME = 'AppCode' 
					)
		BEGIN
			ALTER TABLE [dbo].[Applications] ADD AppCode varchar(200) NOT NULL CONSTRAINT DF_Applications_AppCode DEFAULT 'UNKNOWN'
		END

		IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS		
						WHERE TABLE_NAME = 'Modules'
						AND COLUMN_NAME = 'ModuleCode' 
						)
		BEGIN
			ALTER TABLE [dbo].[Modules] ADD ModuleCode varchar(100) NOT NULL CONSTRAINT DF_Modules_ModuleCode DEFAULT 'UNKNOWN'
		END
	
	
END  -- End of PRoc
GO
