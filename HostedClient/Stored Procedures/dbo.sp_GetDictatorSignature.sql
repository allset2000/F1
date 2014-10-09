
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/6/2014
-- Description: SP used to pull the multi line signature data for Edit1 (currently used by dictateAPI)
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDictatorSignature] (
	 @ClinicId int,
	 @DictatorId  varchar(100)
) AS 
BEGIN
	select Signature,SignatureImage,ImageName from Dictators where ClinicID = @ClinicId and DictatorName = STUFF(@DictatorId,1,LEN((SELECT ClinicCode FROM Clinics WHERE ClinicID = @ClinicId)),'')
END


GO
