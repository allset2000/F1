SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Samuel Shoultz
-- Create date: 3/23/2015
-- Description: SP used to pull the MessageThread by threadid
--Modified By :Raghu
--Modified Date : 07/28/2015
--Decription: ThreadAdminUserID  added
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMessageThreadByThreadID]
	@ThreadId AS VARCHAR(100)
AS 
BEGIN
	 SELECT 
		   MH.MessageThreadId, 
		   MH.ThreadID, 
		   MH.ThreadOwnerID,
		   MH.PatientID,
		   MH.IsActive,
		   MH.PassPhrase,
		   MH.ThreadAdminUserID,		 
		   MH.CreatedDate
	   FROM MessageThreads MH WITH(NOLOCK)	 
	   WHERE ThreadID = @ThreadId
END

GO
