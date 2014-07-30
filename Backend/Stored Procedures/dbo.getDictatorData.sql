SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getDictatorData] (
   @DictatorID varchar(50)
) AS
	SELECT [FirstName], [MI], [LastName], [Suffix], [Initials], [Signature], [User_Code], [Email], 
		   [PhoneNo], [FaxNo], [MedicalLicenseNo], 
		   [Custom1], [Custom2], [Custom3], [Custom4], [Custom5]
	FROM   dbo.Dictators
    WHERE (DictatorID = @DictatorID)
RETURN
GO
