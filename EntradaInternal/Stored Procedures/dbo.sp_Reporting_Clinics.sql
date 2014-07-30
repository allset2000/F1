SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*  =======================================================
Author:			Jen Blumenthal 
Create date:	2/5/2013
Description:	Retrieves list of clinics used in reporting.  
				Populates the ClinicCode (or @PayTypeVar) 
				parameter list in reports.

change log:

date	user			description
3/25/13	jblumenthal		commented out all clinic codes that
						are not in the clinic table.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Clinics]

AS
BEGIN

SET NOCOUNT ON


	SELECT ClinicID,
		   ClinicCode,
		   ClinicName
	FROM Entrada.dbo.Clinics
	where isnull(ClinicCode, '') <> '' -- is not null
	
	--UNION ALL
	
	--SELECT '- ALL -',
	--	   '- ALL -'
	ORDER BY ClinicName	
		   
	--UNION ALL
	
	--SELECT 'QID', 
	--	   'QID'
	
	--UNION ALL
	
	--Select '63','Ortho Tennessee KOC Only'
	
	--UNION ALL
	
	--Select '59','Ortho Tennessee MOC Only'
	
	--UNION ALL
	
	--Select '51','Ortho Tennessee OSOR Only'
	
	--UNION ALL
	
	--Select '60','Ortho Tennessee UOS Only'
	

END
GO
