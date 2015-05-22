
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Dustin Dorsey
-- Create date: 4/30/15
-- Description: Temp SP used to update values in ExpressLinkConfiguration Table
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM2682_UpdateExpressLinkConnString] 
(
@ID int,
@ConnectionString Varchar(MAX) = NULL,
@DaysForward smallint = NULL,
@DaysBack smallint = NULL,
@LastScheduleSync datetime = NULL,
@LastPatientSync datetime = NULL,
@LastClinicalsSync datetime = NULL
) 

AS 

BEGIN
	
	IF (@ConnectionString is not null)
	BEGIN
		UPDATE expressLinkConfigurations SET ConnectionString=@ConnectionString where ID = @ID 
	END

	IF (@DaysForward is not null)
	BEGIN
		UPDATE expressLinkConfigurations SET DaysForward = @DaysForward where ID = @ID 
	END

	IF (@DaysBack is not null)
	BEGIN
		UPDATE expressLinkConfigurations SET DaysBack = @DaysBack where ID = @ID 
	END

	IF (@LastScheduleSync is not null)
	BEGIN
		UPDATE expressLinkConfigurations SET LastScheduleSync = @LastScheduleSync where ID = @ID 
	END
	
	IF (@LastPatientSync is not null)
	BEGIN
		UPDATE expressLinkConfigurations SET LastPatientSync = @LastPatientSync where ID = @ID 
	END

	IF (@LastClinicalsSync is not null)
	BEGIN
	UPDATE expressLinkConfigurations SET LastClinicalsSync = @LastClinicalsSync where ID = @ID 
	END

END


GO
