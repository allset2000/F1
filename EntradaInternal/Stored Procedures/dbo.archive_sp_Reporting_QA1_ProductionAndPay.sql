SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "QA1 Production and Pay Report.rdl"
				
change log

date		username		description
======================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_QA1_ProductionAndPay]
	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(100) 
	
AS
BEGIN

	SELECT  EditorID_QA1, 
			E.FirstName, 
			E.LastName, 
			CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101) AS JobDate, 
			COUNT(Jobs_QA.JobNumber) AS JobCount, 
			SUM(NumChars_QA1) AS NumVBC, 
			SUM(NumVBC_QA1) AS NumChars
	FROM Jobs_QA WITH (NOLOCK)
	INNER JOIN Jobs_EditingData WITH (NOLOCK) ON Jobs_QA.JobNumber=Jobs_EditingData.JobNumber 
	INNER JOIN Editors WITH (NOLOCK) ON Jobs_QA.EditorID_QA1=Editors.EditorID 
	INNER JOIN Entrada.dbo.Editors_Pay EP WITH (NOLOCK) ON E.EditorID = EP.EditorID
	WHERE Jobs_QA.ReturnedOn_QA1>=@ReceivedOn 
	  AND Jobs_QA.ReturnedOn_QA1<=@ReceivedOn2 
	  AND PayType=@PayTypeVar
	GROUP BY EditorID_QA1, LastName, FirstName, CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101)
	ORDER BY EditorID_QA1, LastName, FirstName, CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101)
			 
END

GO
