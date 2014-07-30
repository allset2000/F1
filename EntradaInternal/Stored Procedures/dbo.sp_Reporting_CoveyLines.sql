SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/8/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time (EXT).rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_CoveyLines]

	@BeginDate datetime, 
	@EndDate datetime,
	@DictatorID varchar(50)

AS
BEGIN

	

	SELECT  Editors.EditorID, 
			Editors.FirstName, 
			Editors.LastName, 
			T.NumJobs, 
			T.NumVBC as [NumChars], 
			(CAST(T.NumVBC AS DECIMAL(10, 2)) / 65) as [Lines],
			Editors_Pay.PayLineRate, 
			Editors_Pay.PayEditorPayRoll, 
			Editors_Pay.PayType, 
			Editors_Pay.PayrollCode, 
			Editors.ClinicID
	FROM    [Entrada].[dbo].Editors 
		INNER JOIN (SELECT Jobs.EditorID, COUNT(Jobs.JobNumber) AS NumJobs, 
						SUM(Jobs_EditingData.NumVBC_Editor) AS NumVBC
					 FROM [Entrada].[dbo].Jobs 
						INNER JOIN [Entrada].[dbo].Jobs_EditingData ON 
							Jobs.JobNumber = Jobs_EditingData.JobNumber
					 WHERE (Jobs.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)) 
						AND DictatorID = @DictatorID
					 GROUP BY Jobs.EditorID) AS T ON 
				Editors.EditorID = T.EditorID 
		LEFT OUTER JOIN [Entrada].[dbo].Editors_Pay ON 
			Editors.EditorID = Editors_Pay.EditorID
	ORDER BY Editors_Pay.PayEditorPayRoll DESC, Editors_Pay.PayType, Editors.LastName

END
GO
