SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 01/27/2016
-- Description:	This SP will return STAT history for a job
--EXEC getJobSTATFromHitory @jobnumber=2016012500000002
-- =============================================
CREATE PROCEDURE [dbo].[getJobSTATFromHitory] 
@JobNumber varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	
	SELECT TOP 1 [JobHistoryID]
      ,[JobNumber]
      ,[MRN]
      ,[JobType]
      ,[CurrentStatus]
      ,[DocumentID]
      ,[UserId]
      ,CONVERT(VARCHAR(40),[HistoryDateTime]) AS HistoryDateTime
      ,[FirstName]
      ,[MI]
      ,[LastName]
      ,[DOB]
      ,[IsHistory]
      ,[STAT]
	FROM [dbo].[Job_History]
	WHERE JobNumber = @JobNumber and STAT = 1 ORDER BY JobHistoryID DESC

END
GO
