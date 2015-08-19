USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GeProviderbyUser]    Script Date: 8/17/2015 11:16:47 AM ******/
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
CREATE PROCEDURE [dbo].[proc_GeProviderbyUser] 
 
 @userid int
AS  
BEGIN 
  

SELECT d.[DictatorID]
      ,d.[DictatorName]
      ,d.[ClinicID]
      ,d.[Deleted]
      ,d.[DefaultJobTypeID]
      ,d.[Password]
      ,d.[Salt]
      ,d.[FirstName]
      ,d.[MI]
      ,d.[LastName]
      ,d.[Suffix]
      ,d.[Initials]
      ,d.[Signature]
      ,d.[EHRProviderID]
      ,d.[EHRProviderAlias]
      ,d.[DefaultQueueID]
      ,d.[VRMode]
      ,d.[CRFlagType]
      ,d.[ForceCRStartDate]
      ,d.[ForceCREndDate]
      ,d.[ExcludeStat]
      ,d.[SignatureImage]
      ,d.[ImageName]
      ,d.[UserId]
      ,d.[SRETypeId]
	  ,ux.BackenddictatorID
  FROM [EntradaHostedClient].[dbo].[Dictators] d
  inner join UserProviderXref ux on d.dictatorid=ux.providerid
  
   where ux.userid=@userid

	
END  

--select * from UserProviderXref

