SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_GetDictatorSignature] (
	 @ClinicId int,
	 @DictatorId  varchar(100)
) AS 
BEGIN
	select Signature,SignatureImage,ImageName from Dictators where ClinicID = @ClinicId and DictatorName = STUFF(@DictatorId,1,LEN((SELECT ClinicCode FROM Clinics WHERE ClinicID = @ClinicId)),'')
END


GO
