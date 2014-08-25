SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- [Get_CRFlagDetails] '57', 'enarhunter','1'
CREATE PROCEDURE [dbo].[Get_CRFlagDetails]
(
	@ClinicID VARCHAR(30),
	@Dictator VARCHAR(30),
	@Stat VARCHAR(1)
)
AS
BEGIN	
	DECLARE @DictatorName VARCHAR(30) = ''
	SET @DictatorName = STUFF(LOWER(@Dictator),1,LEN((SELECT ClinicCode FROM Clinics WHERE ClinicID = CONVERT(INT,@ClinicID))),'')
	IF EXISTS(SELECT * FROM Dictators WHERE DictatorName = @DictatorName AND CRFlagType != 0)
	BEGIN
		SELECT 
			CASE	WHEN	@Stat = '1' AND ExcludeStat = 1 THEN 'None'
					WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 0 THEN 'None'
					WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 2 THEN 'Bypass CR'
					WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 1 
								AND ISNULL(ForceCRStartDate,'') <> ''
								AND ISNULL(ForceCREndDate,'') <> ''
							THEN 
								CASE WHEN (CONVERT(VARCHAR(10), ForceCRStartDate, 111) <= CONVERT(VARCHAR(10), GETDATE() , 111) AND CONVERT(VARCHAR(10), ForceCREndDate, 111) >= CONVERT(VARCHAR(10), GETDATE() , 111))
									THEN 'Force CR' ELSE 'None' END
					WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 1 
								AND ISNULL(ForceCRStartDate,'') <> ''
								AND ISNULL(ForceCREndDate,'') = ''
							THEN
								CASE WHEN (CONVERT(VARCHAR(10), ForceCRStartDate, 111) <= CONVERT(VARCHAR(10), GETDATE() , 111))
									THEN 'Force CR' ELSE 'None' END
					ELSE 'None' 
				END	AS CRFlag	
		FROM Dictators 
		WHERE DictatorName = @DictatorName AND ClinicID = CONVERT(INT,@ClinicID)	
	END
	ELSE IF EXISTS(SELECT * FROM Clinics WHERE ClinicID = @ClinicID)
			BEGIN
				SELECT 
					CASE	WHEN	@Stat = '1' AND ExcludeStat = 1 THEN 'None'
							WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 0 THEN 'None'
							WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 2 THEN 'Bypass CR'
							WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 1 
										AND ISNULL(ForceCRStartDate,'') <> ''
										AND ISNULL(ForceCREndDate,'') <> ''
									THEN 
										CASE WHEN (CONVERT(VARCHAR(10), ForceCRStartDate, 111) <= CONVERT(VARCHAR(10), GETDATE() , 111) AND CONVERT(VARCHAR(10), ForceCREndDate, 111) >= CONVERT(VARCHAR(10), GETDATE() , 111))
											THEN 'Force CR' ELSE 'None' END
							WHEN	(@Stat = '0' OR (@Stat = '1' AND ExcludeStat = 0)) AND CRFlagType = 1 
										AND ISNULL(ForceCRStartDate,'') <> ''
										AND ISNULL(ForceCREndDate,'') = ''
									THEN
										CASE WHEN (CONVERT(VARCHAR(10), ForceCRStartDate, 111) <= CONVERT(VARCHAR(10), GETDATE() , 111))
											THEN 'Force CR' ELSE 'None' END
							ELSE 'None'
						END AS CRFlag			
				FROM Clinics 
				WHERE ClinicID = @ClinicID
			END
	ELSE
	BEGIN
		SELECT 'None' AS CRFlag
	END
END
GO
