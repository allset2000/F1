SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwPatientsSearch]
AS
SELECT     dbo.vwPatients.*, dbo.Jobs.ClinicID, dbo.Jobs.DictatorID
FROM         dbo.vwPatients INNER JOIN
                      dbo.Jobs ON dbo.vwPatients.JobNumber = dbo.Jobs.JobNumber
GO
