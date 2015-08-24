
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 07/27/2015
-- Description: SP used to take the HL7 ROW Template, and replace all "column" type variables
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateROWHL7Template]
(
	@JobNumber varchar(20),
	@TemplateId INT
)
AS
BEGIN
	DECLARE @ClientJobNumber varchar(20)
	DECLARE @HL7Template varchar(max)
	DECLARE @Errors varchar(max)

	SET @ClientJobNumber = (select filename from EN_Jobs_Client where JobNumber = @JobNumber)
	SET @HL7Template = (select Template from ROWTemplates where ROWTemplateId = @TemplateId)
	SET @Errors = ''

	IF (@ClientJobNumber is null)
	BEGIN
		IF EXISTS(SELECT 1 from Jobs where JobNumber = @JobNumber)
		BEGIN
			SET @ClientJobNumber = @JobNumber
		END
	END

	CREATE TABLE #Var_Replacement
	(
		FieldName varchar(200),
		VariableName varchar(200),
		IsRequired bit,
		ErrorCode int,
		Processed int
	)
	CREATE TABLE #ret (foundvalue varchar(100))

	INSERT INTO #Var_Replacement(FieldName,VariableName,IsRequired,ErrorCode,Processed)
	select FieldName,VariableName,Required,ErrorCodeId,0 From ROWTemplateVariables where VariableTypeId = 1

	WHILE EXISTS(select 1 from #Var_Replacement where Processed = 0)
	BEGIN
		DECLARE @cur_Var varchar(200)
		DECLARE @cur_Field varchar(200)
		DECLARE @cur_Req bit

		SELECT TOP 1 @cur_Var = VariableName, @cur_Field = FieldName, @cur_Req = IsRequired FROM #Var_Replacement WHERE Processed = 0

		-- Only replace variables that are in the template
		IF (CHARINDEX(@cur_Var, @Hl7Template) > 0)
		BEGIN
			DECLARE @sql varchar(1000)
			SET @sql = 'select ' + @cur_Field + ' from vw_GetROWJobDetails WHERE JobNumber = ''' + @JobNumber + ''''
			INSERT INTO #ret exec (@sql)

			IF (SELECT count(*) FROM #ret) = 0
			BEGIN
				SET @sql = 'select ' + @cur_Field + ' from vw_GetHostedROWJobDetails WHERE JobNumber = ''' + @JobNumber + ''''
				INSERT INTO #ret exec (@sql)
			END

			-- validate if the data returned
			IF EXISTS (select 1 from #ret)
			BEGIN
				DECLARE @ReplaceValue varchar(100)

				SET @ReplaceValue = (select top 1 foundvalue from #ret)
				IF (LEN(@ReplaceValue) <= 0 and @cur_Req = 1)
				BEGIN
					SET @Errors = @Errors + @cur_Var + ', '
				END
				ELSE
				BEGIN 
					SET @HL7Template = (SELECT REPLACE(@HL7Template, @cur_Var, @ReplaceValue))
				END

			END
			ELSE IF @cur_Req = 1
			BEGIN
				SET @Errors = @Errors + @cur_Var + ', '
			END

			TRUNCATE TABLE #ret
		END
		ELSE
		BEGIN
			print('var not found')
			print @cur_Field
			
		END

		UPDATE #Var_Replacement set Processed = 1 where VariableName = @cur_var
	END

	DROP TABLE #Var_Replacement
	DROP TABLE #ret

	SELECT @HL7Template as 'HL7Message', @Errors as 'VariableErrors'
END
GO
