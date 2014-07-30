SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jennifer Blumenthal
Create date:	4/19/13
Description:	Retrieves data for report "New Dictators.rdl"

change log:
date		username		description
4/19/13		jablumenthal	replaced 'New Dictators - original'
							with this report requested by 
							Maria-Jose Moscoso.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_NewDictators_byClinic]
	@BeginDate datetime,
	@EndDate datetime,
	@ClinicCode varchar(max)

AS
BEGIN

	if @BeginDate is null
		BEGIN
			set @BeginDate = '1901-01-01'
		END
		
	if @EndDate is null
		BEGIN
			set @EndDate = '2099-12-31'
		END
		
	SET CONCAT_NULL_YIELDS_NULL OFF
	

	SELECT  J.ClinicID,
			C.ClinicName,
			J.DictatorID, 
			D.FirstName + ' ' + D.LastName + CASE WHEN ISNULL(D.Suffix, '') <> '' THEN NULL ELSE D.Suffix END as DictatorName,
			MIN(CONVERT(DATETIME, CONVERT(VARCHAR(10), J.ReceivedOn, 110))) as LiveDate, 
			COUNT(J.JobNumber) as JobCount
	FROM Entrada.dbo.Jobs J WITH (NOLOCK)
	JOIN Entrada.dbo.Dictators D WITH (NOLOCK)ON
		 J.DictatorID = D.DictatorID
	JOIN Entrada.dbo.Clinics C WITH (NOLOCK) ON
		 J.ClinicID = C.ClinicID	
	WHERE C.ClinicCode in (select ltrim(id) from dbo.ParamParserFn(@ClinicCode,','))
	  AND J.DictatorID not like '%test'
	GROUP BY J.ClinicID, 
			 C.ClinicName, 
			 J.DictatorID, 
			 D.FirstName + ' ' + D.LastName + CASE WHEN ISNULL(D.Suffix, '') <> '' THEN NULL ELSE D.Suffix END
	HAVING MIN(CONVERT(DATETIME, CONVERT(VARCHAR(10), J.ReceivedOn, 110))) BETWEEN @BeginDate AND @EndDate
	ORDER BY C.ClinicName, 
			 MIN(J.ReceivedOn)


END	


GO
