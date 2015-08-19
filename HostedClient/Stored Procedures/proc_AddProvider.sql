USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_AddProvider]    Script Date: 8/17/2015 11:15:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************
** File:  proc_AddProvider.sql
** Name:  spGetClinicById
** Desc:  Get SreTypeId of Clinic  based on clinic id
** Auth:  Entrada Dev

**************************
** Change History
******************
** Ticket       Date	    Author           Description	
** --           --------    -------          ------------------------------------
** D.2 - 4355   6/8         Entrada Dev      Added new Providers  / variables to the SP
**
*******************************/
CREATE PROCEDURE [dbo].[proc_AddProvider] 
 
  @providerid varchar(500),@userid int
AS  
BEGIN 
  
 
  IF OBJECT_ID('tempdb..#tblproviderUser') IS NOT NULL
drop table #tblproviderUser
create table #tblproviderUser (userid int null,providerId varchar(500),backenddictatorid varchar(500))
insert into #tblproviderUser (providerId,backenddictatorid) select Cast(sp.splitdata as int)as providerId,concat(c.cliniccode,dictatorname)as backenddictatorid from dbo.fnSplitString(@providerid,',') sp
inner join Dictators d on d.dictatorid= Cast(sp.splitdata as int)
inner join clinics c  on c.ClinicID=d.ClinicID
update  #tblproviderUser set userid=@userid where providerId is not null


delete from UserProviderXref where userid=@userid

insert into UserProviderXref (userid,providerid,backenddictatorid)select * from #tblproviderUser


	
END  
