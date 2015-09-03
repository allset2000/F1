/****** Object:  StoredProcedure [dbo].[sp_UpdateJobDeliveryRule]    Script Date: 8/19/2015 3:35:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to update Job Delivery Rules and to respective table based on method value
-- =============================================  
CREATE PROCEDURE [dbo].[sp_UpdateJobDeliveryRule] 
(
	@ClinicID INT 
	, @LocationID INT 
	, @DictatorName VARCHAR(50)
	, @JobType VARCHAR(100)
	, @Method INT
	, @RuleName VARCHAR(50)
	, @AvoidRedelivery BIT
	, @RenamingRule VARCHAR(MAX)
	, @FieldData VARCHAR(MAX)
	, @Message VARCHAR(MAX)
	, @RuleID INT
	, @RuleTypeID INT
)
AS
BEGIN	
	IF(@RuleTypeID = -1)
	BEGIN
		-- Updating Job Delivery Rules table only			
		UPDATE JobDeliveryRules
		SET ClinicID = @ClinicID
			, LocationID = @LocationID
			, DictatorName = @DictatorName
			, JobType = @JobType
			, Method = @Method
			, RuleName = @RuleName
			, AvoidRedelivery = @AvoidRedelivery
		WHERE RuleID = @RuleID
	END
	ELSE
	BEGIN
		-- Updating Child Rules table along with JobDEliveryRules table
		DECLARE @Tbl VARCHAR(30)
		DECLARE @Value VARCHAR(MAX)
		DECLARE @Sql VARCHAR(MAX)

		Update JobDeliveryRules
		SET RuleName = @RuleName, AvoidRedelivery = @AvoidRedelivery
		WHERE RuleID = @RuleID

		SET @Tbl = (SELECT (CASE WHEN @Method = 1100 THEN 'ROW_ImageRules'
								WHEN @Method = 100 THEN 'ROW_DocumentRules'
								WHEN @Method = 300 THEN 'ROW_NextGenDoc'
								WHEN @Method = 600 THEN 'ROW_NextGenNote'
								WHEN @Method = 400 THEN 'ROW_NextGenDD'
								WHEN @Method = 1000 THEN 'ROW_NextGenImage'
								WHEN @Method = 200 THEN 'ROW_HL7Rules' END))

		SET @Value = (SELECT (CASE WHEN CHARINDEX('Nextgen', @Tbl) > 0 THEN 'ClinicID = '+CONVERT(VARCHAR,@ClinicID)+', LocationID = '+CONVERT(VARCHAR,@LocationID)+', DictatorName = '''+@DictatorName+''', FieldData = '''+@FieldData+''', RuleName = '''+@RuleName+''''
						WHEN (@Tbl = 'ROW_ImageRules' OR @Tbl = 'ROW_DocumentRules') THEN 'ClinicID = '+CONVERT(VARCHAR,@ClinicID)+', LocationID = '+CONVERT(VARCHAR,@LocationID)+', DictatorName = '''+@DictatorName+''', RenamingRule = '''+@RenamingRule+''', RuleName = '''+@RuleName+''''
						WHEN @Tbl = 'ROW_HL7Rules' THEN 'ClinicID = '+CONVERT(VARCHAR,@ClinicID)+', LocationID = '+CONVERT(VARCHAR,@LocationID)+', DictatorName = '''+@DictatorName+''', Message = '''+@Message+''', FieldData = '''+@FieldData+''', RuleName = '''+@RuleName+'''' END))

		SET @Sql = 'UPDATE ' + @Tbl + ' SET ' + @Value + ' WHERE RuleId = '+ CONVERT(VARCHAR,@RuleTypeID) +''
		--ClinicID = ' + CONVERT(VARCHAR,@ClinicID) + ' AND ISNULL(RuleName,'''') = ''' + @RuleName + ''' AND ISNULL(DictatorName,'''') = ''' + @DictatorName + ''''
		EXECUTE(@Sql)
	END
END



GO


