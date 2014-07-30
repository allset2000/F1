SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- ============================================================
-- Author:			Jen Blumenthal
-- Create date:		2/12/2013
-- Description:		Retrieves editor production data for report
--					for report "Client Standard Report - Editor Production by Day by Dictator (Self-Edit Customers).rdl"
--
-- Self-Edit Customers per Cindy Gulley:
--  CMC-partial self edit
--  SMOC-full self edit
--  TOG-full self edit
--  MOG-partial self edit
--  AAL-full self edit
--  BMC-partial self edit
--  PAN-partial self edit
--  AGH—full self edit
--  CMA-partial self edit
--  CCV-full self edit
--  DSP-full self edit
--  MOW-partial self edit
--  PCL-full self edit
-- ============================================================
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_SelfEditCustomers]

	@BeginDate datetime, 
	@EndDate datetime,
	@PayTypeVar varchar(25) 

AS
BEGIN

SET CONCAT_NULL_YIELDS_NULL OFF

	SELECT  E.LastName + ', ' + E.FirstName AS EditorName,
			E.EditorID,
			EP.PayType AS EditorGroup,
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END AS ClinicName,
			J.DictatorID,
			coalesce(D.[signature], D.FirstName + ' ' + D.LastName + CASE
																		WHEN isnull(D.Suffix, '') = '' THEN NULL
																		ELSE ', ' + D.Suffix
																	 END) AS DictatorName,
			J.JobNumber,
			JED.NumVBC_Editor as Chars,																	 
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS Lines,
			convert(datetime, convert(varchar(10), J.CompletedOn, 101)) as CompletedOn
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
	JOIN Entrada.dbo.Clinics C WITH(NOLOCK) 
		 ON J.ClinicID = C.ClinicID
	JOIN Entrada.dbo.Editors E WITH(NOLOCK) 
		 ON J.EditorID = E.EditorID
	JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) 
		 ON J.JobNumber = JED.JobNumber
	JOIN Entrada.dbo.Editors_Pay EP WITH (NOLOCK) 
		 ON E.EditorID = EP.EditorID
	JOIN Entrada.dbo.Dictators D WITH (NOLOCK) 
		 ON J.DictatorID = D.DictatorID
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND C.ClinicCode in ('CMC', 'SMOC', 'TOG', 'MOG', 'AAL', 'BMC', 'PAN', 'AGH', 'CMA', 'CCV', 'DSP', 'MOW', 'PCL')  --self-edit customers only per Cindy Gulley
	  AND C.ClinicCode = CASE @PayTypeVar
							WHEN '- All -' THEN C.ClinicCode
							ELSE @PayTypeVar
						 END
	ORDER BY E.LastName + ', ' + E.FirstName,
			 C.ClinicName + CASE
							  WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							  ELSE ' (' + C.ClinicCode + ')'
						    END,
			 coalesce(D.[signature], D.FirstName + ' ' + D.LastName + CASE
																		WHEN isnull(D.Suffix, '') = '' THEN NULL
																		ELSE ', ' + D.Suffix
																	  END)

END

GO
