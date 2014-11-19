SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeEditorPay]
(
	@vEditorID VARCHAR(50) = ''
	, @mPayLineRate MONEY = ''
	, @vPayEditorPayRoll VARCHAR(1) = ''
	, @vPayType VARCHAR(100) = ''
	, @vPayrollCode VARCHAR(50) = ''
)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM [dbo].[Editors_Pay] WHERE ([EditorID] = @vEditorID))  
	BEGIN  
		INSERT INTO [dbo].[Editors_Pay]
			   ([EditorID]
			   ,[PayLineRate]
			   ,[PayEditorPayRoll]
			   ,[PayType]
			   ,[PayrollCode])
		 VALUES
			   (@vEditorID
			   ,@mPayLineRate
			   ,@vPayEditorPayRoll
			   ,@vPayType
			   ,@vPayrollCode)
	END
	ELSE
	BEGIN
		UPDATE [dbo].[Editors_Pay]
		SET
			[PayLineRate] = @mPayLineRate
			, [PayEditorPayRoll] = @vPayEditorPayRoll
			, [PayType] = @vPayType
			, [PayrollCode] = @vPayrollCode
		WHERE [EditorID] = @vEditorID
	END
END
GO
