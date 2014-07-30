SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*  =======================================================
Author:			Jen Blumenthal 
Create date:	4/1/2013
Description:	Retrieves list of AccountManagers used in reporting.
				Populates the Account Manager (or @AM) 
				parameter list in reports.  

change log:

date	user			description
======================================================= */
create PROCEDURE [dbo].[sp_Reporting_AccountManagers]

AS
BEGIN

SET NOCOUNT ON

SELECT AcctManagerName
FROM (
		SELECT distinct AcctManagerName
		FROM EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref

		union all

		Select 'Unknown' as AcctManagerName
	 ) a
ORDER BY AcctManagerName
	 

END
GO
