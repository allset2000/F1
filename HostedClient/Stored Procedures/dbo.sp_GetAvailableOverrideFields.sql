SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/26/2015
-- Description: SP used to obtain the override fields avaialble for the given job
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAvailableOverrideFields]
(
	@JobNumber varchar(20),
	@HostedJobNumber varchar(20)
)
AS
BEGIN
	DECLARE @VendorId INT

	SET @VendorId = (SELECT C.EHRVendorId FROM Jobs J INNER JOIN Clinics C on C.ClinicId = J.ClinicId WHERE J.JobNumber = @HostedJobNumber)

	SELECT FieldId,FieldName,EHRVendorId 
	FROM ROWOverrideFields 
	WHERE FieldID not in (SELECT FieldID FROM ROWOverrideValues WHERE JobNumber = @JobNumber)
	AND EHRVendorId = @VendorId
END


GO
