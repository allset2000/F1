
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 8/20/2015
-- Description: SP used to pull the list of pending ACKS for jobs
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPendingJobsToACK]
AS 
BEGIN

	CREATE TABLE #tmp_hl7ack
	(
		JobId int,
		JobNumber varchar(20),
		AppointmentId varchar(100),
		EHREncounterId varchar(50),
		EHRPracticeId varchar(50),
		AckTemplateId int,
		ChangedDate datetime,
		HL7Message varchar(max),
		HL7Errors varchar(max),
		Processed int
	)
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

	INSERT INTO #tmp_hl7ack
	SELECT TOP 100 J.JobID, J.JobNumber, S.AppointmentId, S.EHREncounterId, C.EHRClinicId, JT.ACKTemplateId, JR.ChangedDate, '', '', 0
	FROM Jobs_Row JR
		INNER JOIN Jobs J on J.JobID = JR.JobId
		INNER JOIN JobTypes JT on JT.JobTypeId = J.JobTypeId
		INNER JOIN Encounters E on E.EncounterId = J.EncounterId
		LEFT  JOIN Schedules S on S.ScheduleId = E.ScheduleId
		INNER JOIN Clinics C on C.Clinicid = J.ClinicId
	WHERE ACKStatus = 150
	ORDER BY JR.ChangedDate

	WHILE EXISTS(select 1 from #tmp_hl7ack where Processed = 0)
	BEGIN
		DECLARE @cur_jobnumber varchar(20)
		DECLARE @cur_templateid int
		DECLARE @HL7Template varchar(max)
		DECLARE @Errors varchar(max)
	
		SELECT top 1 @cur_jobnumber = JobNumber, @cur_templateid = AckTemplateId from #tmp_hl7ack where Processed = 0
		SET @HL7Template = (select Template from ROWTemplates where ROWTemplateId = @cur_templateid)
		SET @Errors = ''

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
				SET @sql = 'select ' + @cur_Field + ' from vw_GetHostedACKJobDetails WHERE JobNumber = ''' + @cur_jobnumber + ''''
				INSERT INTO #ret exec (@sql)

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

		UPDATE #tmp_hl7ack SET Processed = 1, HL7Message = @HL7Template, HL7Errors = @Errors WHERE JobNumber = @cur_jobnumber
		UPDATE #Var_Replacement SET Processed = 0

	END

	SELECT * FROM #tmp_hl7ack

	DROP TABLE #tmp_hl7ack
	DROP TABLE #Var_Replacement
	DROP Table #ret
END
GO
