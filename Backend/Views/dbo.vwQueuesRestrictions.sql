SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwQueuesRestrictions]
AS
SELECT     QueueID, ISNULL(EditorID, '') AS EditorID, ISNULL(ClinicID, 0) AS ClinicID, ISNULL(Location, 0) AS Location, ISNULL(DictatorID, '') AS DictatorID
FROM         dbo.Queue_Restrictions

GO
