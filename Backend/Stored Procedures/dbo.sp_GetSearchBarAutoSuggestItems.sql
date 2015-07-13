SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 07/10/2015
-- Description:	This SP is used to pull data for Ever present Search bar in new portal
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetSearchBarAutoSuggestItems]
 @searchParam varchar(50),
 @clinicID int
AS
BEGIN

	SET NOCOUNT ON;
	Declare @jobNumber varchar(20) Declare @dictatorId varchar(20) Declare @dictatorName varchar(20) Declare @mrn varchar(20) 
	Declare @fName varchar(20) Declare @lName varchar(20) 
	select  @jobNumber = JobNumber from Jobs where JobNumber = @searchParam
	select  @dictatorId = DictatorID, @dictatorName= FirstName + LastName  from Dictators Jobs where (FirstName like ''+@searchParam+'%'  or  LastName like ''+@searchParam+'%' )and ClinicID = @clinicID
	select  @mrn = MRN from Jobs_Patients where MRN = @searchParam
	select  @fName = FirstName from Jobs_Patients where FirstName like ''+@searchParam+'%'
	select  @lName = LastName from Jobs_Patients where LastName like ''+@searchParam+'%'
	
	select @jobNumber as JobNumber, @dictatorid as DitatorID, @dictatorName as DictatorName, @mrn as MRN, @fName as FirstName, @lName as LastName	
END
