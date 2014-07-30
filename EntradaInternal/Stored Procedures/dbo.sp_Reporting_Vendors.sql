SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*  =======================================================
Author:			Jen Blumenthal 
Create date:	3/27/2013
Description:	Retrieves list of vendors used in reporting.  
				Populates the VendorCode (or @VendorCode) 
				parameter list in reports.  Only these
				vendor codes are included per Cindy Gulley:
				('PRO', 'EHS', 'CEL', 'QID', 'PTI', 'MAP', 'MTP')

change log:

date		user			description
4/29/13		jablumenthal	added 'HTC' per Cindy Gulley.
6/25/13		lsoto			added 'STT' per David per Cindy G.
06/12/14	iswindle		added 'SCR' per David per Cindy G.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Vendors]

AS
BEGIN

SET NOCOUNT ON

SELECT  'UNK' as CompanyCode,
		'UNKNOWN' as CompanyName
		
UNION ALL
		
SELECT  CompanyCode,
		CompanyName
FROM Entrada.dbo.DSGCompanies
WHERE CompanyCode in ('ENT', 'PRO', 'EHS', 'CEL', 'QID', 'PTI', 'MAP', 'MTP', 'HTC', 'STT','SCR')
order by CompanyCode
	

END
GO
