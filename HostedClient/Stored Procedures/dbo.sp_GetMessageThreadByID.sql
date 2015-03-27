SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Samuel Shoultz
-- Create date: 3/23/2015
-- Description: SP used to pull the MessageThread by threadid
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMessageThreadByID]
	@ThreadId AS VARCHAR(100)
AS 
BEGIN
	SELECT MessageThreadId, ThreadID, ThreadOwnerID, PatientID, IsActive, PassPhrase FROM MessageThreads WHERE ThreadID = @ThreadId
END
GO
