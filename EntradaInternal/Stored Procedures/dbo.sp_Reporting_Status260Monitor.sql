SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/27/2012
-- Description:	Retrieves turnaround summary data
--		for report "Summary Turnaround Time.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_Status260Monitor]

AS

BEGIN

	DECLARE @NumCount int
	
	select @NumCount = COUNT(*)
	from [Entrada].[dbo].jobstatusa
	where status = 260
	and StatusDate < getdate()-.005;
	
	if @NumCount = 0
		BEGIN
			SELECT 1/0
		END
	ELSE
		BEGIN 
			select jobnumber, [status], statusdate, [path] 
			from [Entrada].[dbo].jobstatusa
			where status = 260
			and StatusDate < getdate()-.005
			order by statusdate
		END
	
END	


GO
