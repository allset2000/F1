SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[qryClinicDictatorContractions] (
   @ClinicID smallint,
   @DictatorID varchar(50)
) AS
   (SELECT Contraction, ContractionText 
	FROM   dbo.Dictator_Contractions
    WHERE (DictatorID = @DictatorID)
    ) UNION (
	SELECT Contraction, ContractionText 
	FROM   dbo.Clinic_Contractions
	WHERE (ClinicID = @ClinicID) AND 
	       Contraction NOT IN (SELECT Contraction 
							   FROM dbo.Dictator_Contractions 
							   WHERE (DictatorID = @DictatorID)) 
    
    ) UNION (
    SELECT Contraction, ContractionText 
	FROM   dbo.Contractions
	WHERE Contraction NOT IN (SELECT Contraction 
							  FROM dbo.Dictator_Contractions 
							  WHERE (DictatorID = @DictatorID)) AND
		  Contraction NOT IN (SELECT Contraction 
							  FROM dbo.Clinic_Contractions 
							  WHERE (ClinicID = @ClinicID))
	)							  
RETURN
GO
