SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 3/7/2015
-- Description: SP Used to get clinic dictators and dictator information for the admin console UI
-- Updated: 04/12/2016 - Added Rhythm parameters
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClinicAtiveDictators] (
	@ClinicId int
) AS 
BEGIN

	SELECT CASE WHEN U.UserName is null THEN '' ELSE U.UserName END as 'UserName',
		   CASE WHEN U.UserId is null THEN 0 ELSE U.UserId END as 'UserId', 
		   D.DictatorID,
		   D.DictatorName,
		   D.ClinicId,
		   D.Deleted,
		   D.FirstName,
		   D.MI,
		   D.LastName,
		   D.Suffix,
		   D.Initials,
		   D.Signature,
		   D.EHRProviderID,
		   D.EHRProviderAlias,
		   D.VRMode,
		   (SELECT ClinicCode FROM Clinics WHERE ClinicID = @ClinicId) AS ClinicCode,
		   D.RhythmWorkFlowID,
		   D.AppSetting_DisableSendToTranscription
	FROM Dictators D
		LEFT OUTER JOIN Users U on U.UserId = D.UserId
	WHERE D.ClinicID = @ClinicId AND D.Deleted = 0

END
GO
