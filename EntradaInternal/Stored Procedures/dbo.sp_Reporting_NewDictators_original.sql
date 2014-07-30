SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/6/2012
-- Description:	Retrieves New Dictators data
--		for report "New Dictators.rdl"

--1.	Speaker must have had dictated a job within the current calendar month (mind you, “calendar month” is not the same as “past 30 days”).
--2.	Speaker must not have dictated a job 90 days prior of the current calendar month.

-- change log:
-- date		username		description
-- 4/19/13	jablumenthal	changed name of proc to sp_Reporting_NewDictators_original
--							as a new report with this name was requested.  This original
--							report is being archived.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_NewDictators_original]

	@BaseDate datetime

AS

BEGIN



	DECLARE @BeginDate datetime,
		@EndDate datetime
		
	create Table #Temp(
				ReceivedOn datetime,
				DictatorID varchar(50),
				ClinicID smallint,
				FirstJob bigint,
				LastJob bigint)
				
				
	create table #Results(
				DictatorID varchar(50),
				ClinicID smallint,
				FirstJob datetime,
				LastJob datetime,
				Next2LastJob datetime)
		
	
		
	SELECT @BeginDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@BaseDate)-1),@BaseDate),101)
	SELECT @EndDate = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@BaseDate))),DATEADD(mm,1,@BaseDate)),101)

	INSERT INTO #Temp
	SELECT dateadd(dd, datediff(dd, 0, J.ReceivedOn)+0, 0) as ReceivedOn,
		J.DictatorID,
		J.ClinicID,
		RANK() OVER(PARTITION BY J.DictatorID ORDER BY dateadd(dd, datediff(dd, 0, J.ReceivedOn)+0, 0) ASC) AS FirstJob,
		RANK() OVER(PARTITION BY J.DictatorID ORDER BY dateadd(dd, datediff(dd, 0, J.ReceivedOn)+0, 0) DESC) AS LastJob
	FROM [Entrada].[dbo].Jobs J  WITH(NOLOCK)
	WHERE ReceivedOn > dateadd(day, -365, @BeginDate)
	group by DictatorID,
			ClinicID,
			dateadd(dd, datediff(dd, 0, J.ReceivedOn)+0, 0)		
	order by LastJob

	INSERT INTO #Results
	SELECT T.DictatorID,
		T.ClinicID,
		(SELECT top 1 T1.ReceivedOn
		FROM #Temp T1
		 WHERE T.DictatorID = T1.DictatorID AND
			T1.FirstJob = 1) AS FirstJob,		
		(SELECT top 1 T2.ReceivedOn
		FROM #Temp T2
		 WHERE T.DictatorID = T2.DictatorID AND
			T2.LastJob = 1) AS LastJob,			
		(SELECT top 1 T3.ReceivedOn
		FROM #Temp T3
		 WHERE T.DictatorID = T3.DictatorID AND
			T3.LastJob = 2) AS Next2LastJob
	FROM #Temp T
	GROUP BY T.DictatorID,
		T.ClinicID,
		LastJob

		
	SELECT R.DictatorID,
		ClinicName,
		LastName,
		FirstName,
		FirstJob,
		Next2LastJob,
		LastJob
	FROM #Results R
	INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		R.DictatorID = D.DictatorID
	INNER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		R.ClinicID = C.ClinicID
	WHERE LastJob BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0) AND
		(Next2LastJob <= DATEADD(DAY, -90, @BeginDate) OR Next2LastJob IS NULL)
	GROUP BY R.DictatorID,
		ClinicName,
		LastName,
		FirstName,
		FirstJob,
		Next2LastJob,
		LastJob
	order by ClinicName,
			LastName,
			FirstName
			


			
	drop table #results
	drop table #Temp

	
END	


GO
