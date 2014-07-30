SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeJobParsingError] (
	@JobId  [int],
	@JobNumber  [varchar]  (20),
	@LastExceptionTime  [smalldatetime],
	@LastExceptionMessage  [varchar]  (1024)
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[JobParsingErrors] WHERE ([JobNumber] = @JobNumber))
	 BEGIN
		INSERT INTO [dbo].[JobParsingErrors] (
			[JobId], [JobNumber], [LastExceptionTime], [LastExceptionMessage], [ExceptionCount] 
		) VALUES (
			@JobId, @JobNumber, @LastExceptionTime, @LastExceptionMessage, 1 
		)
	 END
ELSE 
	 BEGIN
		UPDATE [dbo].[JobParsingErrors] 
		 SET
			 [LastExceptionTime] = @LastExceptionTime ,
			 [LastExceptionMessage] = @LastExceptionMessage,
			 [ExceptionCount] = [ExceptionCount] + 1
		WHERE ([JobNumber] = @JobNumber)
	END
GO
