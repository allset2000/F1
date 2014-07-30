SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	returns data for "QA1 Production and Pay Report.rdl"

change log:

date		username		description
4/11/13		jablumenthal	code existed in report.  created proc
							from code then archived proc and
							replaced with new one using the new
							QA workflow tables.
======================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_QA1ProductionAndPay]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(15)  --account managers
	
AS
BEGIN


	SELECT  EditorID_QA1, 
			FirstName, 
			LastName, 
			CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101) AS JobDate, 
			COUNT(Jobs_QA.JobNumber) AS JobCount, 
			SUM(NumChars_QA1) AS NumVBC, 
			SUM(NumVBC_QA1) AS NumChars
	FROM Jobs_QA 
	JOIN Jobs_EditingData ON 
		 Jobs_QA.JobNumber=Jobs_EditingData.JobNumber 
	JOIN Editors ON 
		 Jobs_QA.EditorID_QA1=Editors.EditorID 
	JOIN Editors_Pay ON 
		 Editors.EditorID=Editors_Pay.EditorID
	WHERE Jobs_QA.ReturnedOn_QA1>=@ReceivedOn 
	  AND Jobs_QA.ReturnedOn_QA1<=@ReceivedOn2 
	  AND PayType=@PayTypeVar
	GROUP BY EditorID_QA1, 
			LastName, 
			FirstName, 
			CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101)
	ORDER BY EditorID_QA1, 
			LastName, 
			FirstName, 
			CONVERT(date, Jobs_QA.ReturnedOn_QA1, 101)

			 
END
GO
