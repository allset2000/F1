SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Per Editor-Job-Date TAT Report.rdl"
				
change log:
date		username		description
5/8/13		jablumenthal	altered procedure to new definition
							given by Cindy Gulley.
				
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_PerEditorJobDate_TATReport]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(100)  
	
AS
BEGIN


	--declare @StartDate datetime,
	--		@EndDate datetime,
	--		@PayTypeVar varchar(100)
			
	--set @startDate = '2013-05-03'
	--set @EndDate = '2013-05-06'
	--set @PayTypeVar = 'ENT'

	select  J.EditorID,
			J.JobNumber,
			J.ReceivedOn,
			J.CompletedOn,
			E.LastName + ', ' + E.FirstName as EditorName,
			EP.PayType
	from Entrada.dbo.Jobs J with (nolock)
	join Entrada.dbo.Editors E with (nolock)
		 on J.EditorID = E.EditorID
	left outer join Entrada.dbo.Editors_Pay EP with (nolock)
		 on E.EditorID = EP.EditorID
	where J.ReceivedOn between @ReceivedOn and @ReceivedOn2
	  and EP.PayType = @PayTypeVar
			 
END
GO
