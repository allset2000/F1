SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Jen Blumenthal
Create date:	5/23/13
Description:	Adds or changes Account Managers to their assigned
				clinics in the EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref table
				
ActionIDs:
1 - add a new clinic/acct manager to xref table
2 - assign a new account manager to a clinic that's already in the xref table
3 - remove a clinic from the account manager lists.  this will cause the clinic to show up with account manager of 'unknown'

NOTE:  
This procedure will alter the Reporting_AcctManager_Clinic_Xref table in the EntradaInternal database.  
This table is used to create a list of clinics per Account Manager in many of the reports.  Use this 
procedure if a clinic needs to be assigned to an Account Manager or the assignment needs to be changed.  
This table is used for Reporting ONLY.  It is not connected to the production tables in any way. ~Jen


change log:
date		username		description
5/23/13		jablumenthal	added clinicID 85 & 90 to Julie Engelmann per Ron Spears
6/6/13		jablumenthal	added clinics 'Carolina Regional Orthopaedics' and 'Cardiology Associates of Central CT' to Julie Engelmann per Ron Spears
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_AccountManagerTable]
--declare 
	@ClinicCode varchar(20),
	@AM varchar(25),
	@ActionID int --this tells which action the user wants to do in the Reporting_Clinic_AccgMgr_Xref table
		
AS
BEGIN

	declare @ClinicID smallint
	
--set @ClinicID = (select ClinicID from Entrada.dbo.Clinics where ClinicCode = 'CRO')
--set @AM = 'Engelmann'
--set @ActionID = 1
	
	if @ActionID = 1 --add new clinic/acct manager to xref table
	begin
	
		insert into EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref (cliniccode, clinicid, acctmanagername)
		select  cliniccode, 
				clinicid,
				@AM
		from entrada.dbo.clinics a with (nolock)
		where clinicid = @ClinicID
		  and not exists (select clinicID, AcctManagerName
						  from EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref b with (nolock)
						  where b.ClinicID = @ClinicID
							and b.AcctManagerName = @AM)

	end
	
	if @ActionID = 2  --change the acct manager assignment: assign new acct manager to a clinic already in the table
	begin
	
		update EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref
		set AcctManagerName = @AM
		where ClinicID = @ClinicID
		  and AcctManagerName <> @AM

	end
	
	if @ActionID = 3  --delete the clinic from the Xref table & all acct managers' lists.  these clinics will show up with acct manager of 'unknown'. 
					  --(this does NOT delete it from the Entrada.dbo.Clinics table) 
	begin

		delete from EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref
		where clinicID = @ClinicID
	
	end	
	
	--show final data
	select case
			when X.ClinicID is null then 'Unknown'
			else X.AcctManagerName
		   end as AcctManagerName,
		   C.ClinicName
	from Entrada.dbo.Clinics C with (nolock) 
	left outer join EntradaInternal.dbo.Reporting_Clinic_AcctMgr_Xref X with (nolock)
		 on C.ClinicID = X.ClinicID
	order by case
				when X.ClinicID is null then 'Unknown'
				else X.AcctManagerName
		     end desc, C.ClinicName

END

GO
