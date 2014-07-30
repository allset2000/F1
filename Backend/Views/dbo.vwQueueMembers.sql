SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwQueueMembers]
AS
SELECT     dbo.QueueMembers.*
FROM         dbo.QueueMembers
WHERE     (QueueMemberStatus <> 'X')
GO
