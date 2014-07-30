SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryClinicDictatorAutoText] (
   @ClinicID smallint,
   @DictatorID varchar(50)
) AS

	  (SELECT AutoText_Name, AutoText_Content 
	   FROM   dbo.Dictators_AutoText
     WHERE (DictatorID = @DictatorID)
    ) UNION (
			SELECT AutoText_Name, AutoText_Content
			FROM dbo.ClinicsAutoText
			WHERE (ClinicID = @ClinicID) AND 
						(AutoText_Name NOT IN (SELECT AutoText_Name
																	 FROM dbo.Dictators_AutoText 
																	 WHERE DictatorID = @DictatorID))
    )
RETURN
GO
