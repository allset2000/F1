SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	6/18/13
Description:	Retrieves editor production data
				for report "Billing Invoice Detail.rdl"
				
NOTES:
*dictators with a per-dictator charge get pro-rated during their
first month with Entrada.  The calculation per Matt Smith is:
"(End of Month- Date of Go Live)/30 * Per Dictator Fee"; however,
there is no way to automatically track the go-live date for a dictator
so Matt wants me to use the full per-dictator charge and he will edit
the amounts necessary before sending out invoices.
				
change log

date		username		description
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_BillingInvoiceDetail] 
--declare
	@BeginDate datetime,
	@EndDate datetime
	--,@ClinicCode varchar(10)

AS
BEGIN

SET NOCOUNT ON;

--set @BeginDate = '05/01/2013'
--set @EndDate = '05/31/2013'

	set @BeginDate = convert(date, @BeginDate)
	set @EndDate = convert(date, @EndDate)
	
	if object_id('tempdb..#temp') is not null drop table #temp
	
	create table #temp (id int identity(1,1) primary key,
						ClinicName varchar(200),
						ClinicCode varchar(20),
						DictatorID varchar(50),
						FirstName varchar(50),
						LastName varchar(50),
						--[Signature] varchar(50),
						PayType varchar(100),
						Jobs int,
						TotalLines decimal(12,6),
						LineCharge decimal(5,3),
						TechLineCharge decimal(5,3),
						EditingLineCharge decimal(5,3),
						PerDictatorCharge int,
						JobCharge int,
						SelfEditLines decimal(12,6),
						ENTEditLines decimal(12,6),
						PerDictatorRevenue decimal(12,6))
	
	insert into #temp (ClinicName,
						ClinicCode,
						DictatorID,
						FirstName,
						LastName,
						--[Signature],
						PayType,
						Jobs,
						TotalLines,
						LineCharge,
						TechLineCharge,
						EditingLineCharge,
						PerDictatorCharge,
						JobCharge,
						SelfEditLines,
						ENTEditLines,
						PerDictatorRevenue)
	Select  sumtot.ClinicName,
			sumtot.ClinicCode,
			sumtot.DictatorID,
			sumtot.FirstName,
			sumtot.LastName,
			--sumtot.[Signature],
			sumtot.PayType,
			sumtot.jobs,
			sumtot.TotalLines,
			MB.LineCharge,
			MB.TechLineCharge,
			MB.EditingLineCharge,
			MB.PerDictatorCharge,
			MB.JobCharge,
			case
				when sumtot.ClinicCode = sumtot.PayType then TotalLines
				else 0.0
			end as SelfEditLines,
			case
				when sumtot.ClinicCode <> sumtot.PayType then TotalLines
				else 0.0
			end as ENTEditLines,
			NULL as PerDictatorRevenue
	from (
		Select  tot.ClinicName,
				tot.ClinicCode,
				tot.DictatorID,
				tot.FirstName,
				tot.LastName,
				--tot.[Signature],
				tot.PayType,
				count(tot.JobNumber) as jobs,
				sum(tot.[EntradaLines_w_Spaces]) as TotalLines
		from (
			select  J.JobNumber,
					J.DictatorID,
					D.FirstName,
					D.LastName,
					--D.[Signature],
					J.ClinicID,
					C.ClinicCode,
					C.ClinicName,
					J.EditorID,
					EP.PayType,
					(BJ.DocumentWSpaces / 65.0) as [EntradaLines_w_Spaces]
			from Entrada.dbo.Jobs J with (nolock)
			join Entrada.dbo.Clinics C with (nolock) on J.ClinicID = C.ClinicID
			join Entrada.dbo.Dictators D with (nolock) on J.DictatorID = D.DictatorID
			join Entrada.dbo.Editors E with (nolock) on J.EditorID = E.EditorID
			join Entrada.dbo.Editors_Pay EP with (nolock) on E.EditorID = EP.EditorID
			join [Entrada].dbo.vwRptBillableJobs BJ with (nolock) on J.JobNumber = BJ.JobNumber
			WHERE convert(date, J.CompletedOn) BETWEEN @BeginDate AND @EndDate
			  and D.LastName <> 'Test'  --exclude test dictators
			  --and J.DictatorID = 'panjjohnson'    --for testing
			  --and C.ClinicCode = 'PAN'			--for testing
			 ) tot
		group by tot.ClinicName,
				 tot.ClinicCode,
				 tot.DictatorID,
				 tot.FirstName,
				 tot.LastName,
				 --tot.[Signature],
				 tot.PayType
		) sumtot
	join EntradaInternal.dbo.Reporting_MasterBilling MB with (nolock) on sumtot.ClinicCode = MB.ClinicCode


	--update table with PerDictatorCharge; must do this step separately or duplicate dictator entries and the dictators who are partial self edit (multiple pay types) will get charged twice per dictator
	update #temp
	set PerDictatorRevenue = t.PerDictatorCharge	
	--select temp.ClinicCode, temp.FirstName, temp.LastName, /*temp.DictatorID,*/ temp.ID, t.PerDictatorCharge
	from (
		select ClinicCode, FirstName, LastName, /*DictatorID,*/ min(id) as ID  --I am using firstname/lastname here because it is unique for dictators who have more than 1 entry in the dictators table with different dictatorIDs
		from #temp
		group by ClinicCode, FirstName, LastName --DictatorID	
		 ) temp
	join #temp t
		 on temp.ID = t.ID


	--select final data
	select  ClinicName,
			ClinicCode,
			DictatorID,
			FirstName,
			LastName,
			sum(jobs) as jobs,
			sum(TotalLines) as TotalLines,
			avg(LineCharge) as LineCharge,
			avg(TechLineCharge) as TechLineCharge,
			avg(EditingLineCharge) as EditingLineCharge,
			avg(PerDictatorCharge) as PerDictatorCharge,
			avg(JobCharge) as JobCharge,
			sum(SelfEditLines) as SelfEditLines,
			sum(ENTEditLines) as ENTEditLines,
			sum(PerDictatorRevenue) as PerDictatorRevenue,
			case
				when isnull(sum(JobCharge), 0) = 0 then 0
				--when isnull(JobCharge, '') = '' then 0
				else sum(jobs) * avg(JobCharge)
			end as JobRevenue,
			case
				when ClinicCode = 'SAO' then case
												when sum(jobs) < 100 then avg(LineCharge) * sum(jobs)
												when sum(jobs) >= 100 and sum(jobs) < 200 then $600
												when sum(jobs) >= 201 and sum(jobs) < 300 then $900
												else $1100
											  end
				when ClinicCode = 'SMOC' then sum(TotalLines) * avg(LineCharge)
				when ClinicCode = 'CMC' then (sum(ENTEditLines) * avg(EditingLineCharge)) + (sum(TotalLines) * avg(TechLineCharge))
				else sum(ENTEditLines) * avg(LineCharge)
			end as LineRevenue
	from #temp
	--where ClinicCode = @ClinicCode
	group by ClinicName, ClinicCode, DictatorID, FirstName, LastName	
	order by ClinicName, ClinicCode, DictatorID, FirstName, LastName	


END


/*
--SAO
job revenue = 0
dictator revenue = 0
line revenue = 
  when sum(jobs) < 100 then linecharge * jobs
  when sum(jobs) between 100 and 200 then $600
  when sum(jobs) between 201 and 300 then $900
  when sum(jobs) > 300 then $1100

--RadSource = 
job revenue = jobs * job_charge
dictator revenue = 0
line revenue = 0

--SMOC = 
dictator revenue = 0
job revenue = 0
line revenue = total lines * tech line charge

--Comprehensive Ortho =
job revenue = 0
dictator revenue = 0
line revenue = (ENTeditlines * editing_line_charge) + (totallines * tech_line_charge)

--if dictator charge = 
job revenue = 0
dictator revenue = per dictator charge
line revenue = ENTeditlines * line_charge (which includes a tech line charge)

--if no dictator charge = 
job revenue = 0
dictator revenue = 0
line revenue = ENTeditlines * linecharge (which includes a tech line charge)
*/

GO
