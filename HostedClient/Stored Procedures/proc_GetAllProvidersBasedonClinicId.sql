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
      ,[ClinicID]
      ,[Deleted]
      ,[DefaultJobTypeID]
      ,[Password]
      ,[Salt]
      ,[FirstName]
      ,[MI]
      ,[LastName]
      ,[Suffix]
      ,[Initials]
      ,[Signature]
      ,[EHRProviderID]
      ,[EHRProviderAlias]
      ,[DefaultQueueID]
      ,[VRMode]
      ,[CRFlagType]
      ,[ForceCRStartDate]
      ,[ForceCREndDate]
      ,[ExcludeStat]
      ,[SignatureImage]
      ,[ImageName]
      ,[UserId]
      ,[SRETypeId]
  FROM [EntradaHostedClient].[dbo].[Dictators] where clinicid in(Select clinicIds from #tblclinicIds)
	
END  

