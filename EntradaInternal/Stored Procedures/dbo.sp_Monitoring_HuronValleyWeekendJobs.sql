SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/23/2012
-- Description:	Notifies On-Call editors of any 
--		Huron Valley jobs that we receive over 
--		the weekend. 
--		For report "Evening and Weekend Jobs Received (Huron Valley).rdl"

-- =============================================
CREATE PROCEDURE [dbo].[sp_Monitoring_HuronValleyWeekendJobs]

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @NumCount int
	
	
	IF dbo.fnMonitorScheduled(1) = 0
		BEGIN
			SELECT 1/0
		END
	ELSE		
		BEGIN
	
			SELECT @NumCount = COUNT(*)
			FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
			INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
				J.DictatorID = D.DictatorID
			WHERE J.ClinicID = 45 AND
				ReturnedOn IS NULL AND
				CompletedOn IS NULL
			
			if @NumCount = 0
				BEGIN
					SELECT 1/0
				END
			ELSE
				BEGIN 
					SELECT D.LastName + ', ' + D.FirstName AS Speaker,
						J.JobNumber,
						--CAST(CAST(CONVERT(DATE, J.DictationDate, 101) AS CHAR(25)) + ' ' + SUBSTRING(CAST(CONVERT(TIME, J.DictationTime) AS CHAR(25)), 0, 9) AS DATETIME) AS DictationDateTime,
						J.ReceivedOn,
						CASE J.STAT
							WHEN 1 THEN 'Y'
							ELSE 'N'
						END AS [Stat]
					FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
					INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
						J.DictatorID = D.DictatorID
					WHERE J.ClinicID = 45 AND
						ReturnedOn IS NULL AND
						CompletedOn IS NULL
				END
		END
	
END	

GO
