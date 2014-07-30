SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwClinics]
AS
SELECT     CAST(ClinicID AS int) AS ClinicId, ISNULL(ClinicName, '') AS ClinicName, ISNULL(ClinicCode, '') AS ClinicCode
FROM         dbo.Clinics

GO
