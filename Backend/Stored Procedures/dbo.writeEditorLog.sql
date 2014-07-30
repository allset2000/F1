SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeEditorLog] (
	@EditorID  varchar (50),
	@OperationTime  datetime,
	@OperationName  varchar(64),
	@JobNumber  varchar(20),
	@SuccessFlag  bit,
	@ExceptionMessage varchar(1024),
	@SessionID  varchar (128)
) AS
	INSERT INTO [dbo].[EditorLogs] (
		[EditorID], [OperationTime], [OperationName], [JobNumber], 
		[SuccessFlag], [ExceptionMessage], [SessionID]
	) VALUES (
		@EditorID, @OperationTime, @OperationName, @JobNumber, 
		@SuccessFlag, @ExceptionMessage, @SessionID
	)
	
RETURN
GO
