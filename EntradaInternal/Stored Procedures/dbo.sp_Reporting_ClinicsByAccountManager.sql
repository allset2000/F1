SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jennifer Blumenthal
Create date:	4/26/13
Description:	Retrieves data for report "Unknown Account Managers.rdl"
				This report shows clinics where the account manager
				is unknown and the account manager needs to be added to the 
				EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref table.

change log:
date		username		description
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_ClinicsByAccountManager]
	@AM varchar(max)
	
AS
BEGIN

	Select c.AcctManagerName,
			c.ClinicID,
			c.ClinicCode,
			c.ClinicName
	from (		
			Select  case
						when b.XrefID is null then 'Unknown' 
						else b.AcctManagerName
					end as AcctManagerName,
					a.ClinicID,
					a.ClinicCode,
					a.ClinicName
			from Entrada.dbo.Clinics a
			left outer join EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref b
				 on a.ClinicID = b.ClinicID
				 and a.ClinicCode = b.ClinicCode
			where a.active = 1
			  and isnull(a.ClinicCode, '') <> ''
		 ) c
	where c.AcctManagerName in (select ltrim(id) from EntradaInternal.dbo.ParamParserFn(@AM, ','))
	order by c.AcctManagerName,
			 c.ClinicName
		
				    

END	


GO
