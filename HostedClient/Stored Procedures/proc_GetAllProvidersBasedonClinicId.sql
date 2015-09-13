USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAllProvidersBasedonClinicId]    Script Date: 8/17/2015 11:18:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************************
** File:  spGetClinicById.sql
** Name:  spGetClinicById
** Desc:  Get SreTypeId of Clinic  based on clinic id
** Auth:  Suresh
** Date:  30/05/2015
**************************
** Change History
******************
** Ticket       Date	    Author           Description	
** --           --------    -------          ------------------------------------
** D.2 - 4355   6/8         Sam Shoultz      Added new Clinic values / variables to the SP
**
*******************************/
CREATE PROCEDURE [dbo].[proc_GetAllProvidersBasedonClinicId] 
 
 @clinicID varchar(500)
AS  
BEGIN 

IF OBJECT_ID('tempdb..#tblclinicIds') IS NOT NULL
drop table #tblclinicIds
select Cast(splitdata as smallint)as clinicIds into #tblclinicIds from dbo.fnSplitString(@clinicId,',')

SELECT [DictatorID]
      ,[DictatorName]
      ,D.[ClinicID]
      ,D.[Deleted]
      ,D.[DefaultJobTypeID]
      ,D.[Password]
      ,D.[Salt]
      ,D.[FirstName]
      ,D.[MI]
      ,D.[LastName]
      ,D.[Suffix]
      ,D.[Initials]
      ,D.[Signature]
      ,D.[EHRProviderID]
      ,D.[EHRProviderAlias]
      ,D.[DefaultQueueID]
      ,D.[VRMode]
      ,D.[CRFlagType]
      ,D.[ForceCRStartDate]
      ,D.[ForceCREndDate]
      ,D.[ExcludeStat]
      ,D.[SignatureImage]
      ,D.[ImageName]
      ,D.[UserId]
      ,D.[SRETypeId]
	  ,concat(C.cliniccode,D.DictatorName) as BackendDictatorID
  FROM [EntradaHostedClient].[dbo].[Dictators] D
  inner join clinics C on D.ClinicID=C.ClinicID
  where D.clinicid in(Select clinicIds from #tblclinicIds)
	
END  

