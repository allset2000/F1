SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/7/2014
-- Description: SP used to pull Tags per JobType - the backend JobsTddAllowedTags table is used to order the tags. This is used for Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobTypeTags] (
	 @JobTypeId int
) AS 
BEGIN
	CREATE TABLE #tmp_tags(
		TagId INT,
		JobTypeID INT, 
		Name varchar(50),
		Required bit,
		FieldName varchar(1000),
		FriendlyRequired varchar(5),
		BackendId int,
		Processed int
		)

	INSERT INTO #tmp_tags(TagId,JobTypeID,Name,Required,FieldName,FriendlyRequired,Processed)
	SELECT TagID,JobTypeID,Name,Required,FieldName,CASE WHEN Required = 0 THEN '' ELSE 'Yes' END as 'FriendlyRequired',0
	FROM ExpressNotesTags
	WHERE JobTypeId = @JobTypeId

	DECLARE @JobTypeName varchar(100)
	DECLARE @ClinicId int
	DECLARE @SplitRuleId int

	SELECT @JobTypeName = Name, @ClinicId = ClinicId FROM JobTypes WHERE JobTypeID = @JobTypeId
	SET @SplitRuleId = (SELECT ID FROM EN_JobsTddSplitRules WHERE ClinicID = @ClinicId and JobType = @JobTypeName)

	WHILE EXISTS(SELECT TOP 1 * FROM #tmp_tags WHERE Processed = 0)
	BEGIN
		DECLARE @OrderID int
		DECLARE @cur_Name varchar(50)
		DECLARE @cur_FieldName varchar(1000)
		
		SELECT TOP 1 @cur_Name = Name, @cur_FieldName = FieldName FROM 	#tmp_tags WHERE Processed = 0
		SET @OrderID = (SELECT ID from EN_JobsTddAllowedTags WHERE SplitRuleId = @SplitRuleId and Name = @cur_Name and FieldName = @cur_FieldName)
		
		UPDATE #tmp_tags set BackendId = @OrderID, Processed = 1 WHERE Name = @cur_Name and FieldName = @cur_FieldName 
		
	END

	SELECT * FROM #tmp_tags ORDER BY BackendId

	DROP TABLE #tmp_tags
END


GO
