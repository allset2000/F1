SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary_Sales]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(100)
AS
BEGIN

SET NOCOUNT ON

DECLARE @Speakers TABLE
(
[ID] [bigint] IDENTITY(1,1) NOT NULL,
[SpeakerID] [varchar] (50)
 ) 
 
DECLARE @Editors TABLE
(
[ID] [bigint] IDENTITY(1,1) NOT NULL,
[EditorID] [varchar] (50)
 ) 


DECLARE @Clinics TABLE
(
[ID] [bigint] IDENTITY(1,1) NOT NULL,
[ClinicID] [bigint]
 ) 


INSERT INTO @Clinics (ClinicID)
SELECT DISTINCT(C.ClinicID)
		FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK)
		LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
			J.ClinicID = C.ClinicID 
		WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
		

INSERT INTO @Speakers(SpeakerID)
SELECT DISTINCT(J.DictatorID)
		FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
		LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
			J.DictatorID = D.DictatorID 
		WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
		
		
INSERT INTO @Editors (EditorID)
SELECT DISTINCT (EditorID)
		FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
		WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)

	
SELECT ('Clinic ' + CAST(C.ID AS VARCHAR(10)))  as [Clinic],
		SUBSTRING(J.JobNumber, 0, 7) + 'xxxxxxx' as [Job Number],
		('Speaker ' + CAST(D.ID AS VARCHAR(10))) AS [Dictator],
		('Editor ' + CAST(E.ID AS VARCHAR(10))) AS [Editor],
		J.ReceivedOn as [Received],
		J.CompletedOn as [Completed],
		DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
		CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) 
				/ CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
		COUNT(J2.JobNumber) AS OnTime,
		COUNT(J.JobNumber)  AS Total
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN @Speakers D ON
		J.DictatorID = D.SpeakerID
	LEFT OUTER JOIN @Clinics C ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN @Editors E  ON
		J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Editors_Pay EP WITH(NOLOCK) ON
		E.EditorID = EP.EditorID AND
		EP.PayType = @PayTypeVar
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		J.JobNumber = J2.JobNumber
		AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) 
				/ CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
	GROUP BY C.ID,
			E.ID,
			D.ID,
			J.ReceivedOn,
			J.CompletedOn,
			J.JobNumber
	ORDER BY C.ID,
			E.ID,
			D.ID		
END

GO
