/****** Object:  StoredProcedure [dbo].[sp_GetAllRuleNames]    Script Date: 9/3/2015 3:49:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author: Santhosh 
-- Create date: 07/17/2015  
-- Description: SP used to get Rule Names from respective table
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetAllRuleNames] 
(
	@ClinicID INT 	
	, @DictatorName VARCHAR(50)	
	, @Method INT	
	, @LocationID INT
)
AS
BEGIN
	DECLARE @Tbl VARCHAR(30)
	DECLARE @Value VARCHAR(MAX)
	DECLARE @Sql VARCHAR(MAX)		

	SET @Tbl = (SELECT (CASE WHEN @Method = 1100 THEN 'ROW_ImageRules'
							WHEN @Method = 100 THEN 'ROW_DocumentRules'
							WHEN @Method = 300 THEN 'ROW_NextGenDoc'
							WHEN @Method = 600 THEN 'ROW_NextGenNote'
							WHEN @Method = 400 THEN 'ROW_NextGenDD'
							WHEN @Method = 1000 THEN 'ROW_NextGenImage'
							WHEN @Method = 200 THEN 'ROW_HL7Rules' END))	

	SET @Sql = 'SELECT RuleName AS DeliveryRuleID, RuleName AS DeliveryRuleName FROM ' + @Tbl + ' R
				WHERE R.ClinicID = ' + CONVERT(VARCHAR,@ClinicID) + '
				AND ISNULL(R.DictatorName,'''') = ''' + CONVERT(VARCHAR,@DictatorName) + '''
				AND ISNULL(R.LocationID,''0'') = ' + ISNULL(CONVERT(VARCHAR,@LocationID),0) + ''
	PRINT @Sql
	EXECUTE(@Sql)	
END




GO


