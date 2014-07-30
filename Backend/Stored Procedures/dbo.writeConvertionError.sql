SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeConvertionError] (
	@JobNumber  [varchar]  (20),
	@ErrorMsg  [varchar]  (1024) 
) AS 
INSERT INTO [dbo].[ConvertionErrors] (
	[JobNumber],
	[ErrorMsg] 
) VALUES (
	@JobNumber,
	@ErrorMsg 
)
GO
