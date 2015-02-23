SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 02/20/2015
	Version: 1.0
	Details: SP used to pull an active message thread by thread Id
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_GetMessageThreadByThreadId] (
	@ThreadID VARCHAR(100)
)
AS 
BEGIN
	SELECT MessageThreadID, ThreadID, ThreadOwnerID, ThreadOwnerClinicID, CreatedDate, UpdatedDate, IsActive
	FROM [dbo].[MessageThreads]
	WHERE ThreadID = @ThreadID
END
GO
