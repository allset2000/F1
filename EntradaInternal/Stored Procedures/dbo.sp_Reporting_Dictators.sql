SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*  =======================================================
Author:			Jen Blumenthal 
Create date:	4/22/2013
Description:	Retrieves list of Dictators used in reporting.  
				Populates the DictatorID (or @DictatorID) 
				parameter list in reports.  

change log:

date	user			description
======================================================= */
create PROCEDURE [dbo].[sp_Reporting_Dictators]

AS
BEGIN

SET NOCOUNT ON

	set concat_null_yields_null off

	SELECT DictatorID,
		   case when isnull(suffix, '') = '' then 
											   case when isnull(lastname, '') = '' then null else replace(lastname, '.', '') + ', ' end
											   + firstname
											   + case when isnull(mi, '') = '' then null else ' ' + replace(mi, '.', '') end
											 else
											   case when isnull(lastname, '') = '' then null else replace(lastname, '.', '') + ' ' end
											   + case when isnull(suffix, '') = '' then null else replace(suffix, '.', '') + ', ' end
											   + firstname
											   + case when isnull(mi, '') = '' then null else ' ' + replace(mi, '.', '') end
		   end as DictatorName
	FROM Entrada.dbo.Dictators with (nolock)
	order by LastName,
			 FirstName
			 

END
GO
