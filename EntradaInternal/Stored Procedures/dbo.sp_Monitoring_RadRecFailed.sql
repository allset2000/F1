SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/24/2012
-- Description:	Creates notification if any 
--		Rad jobs failed. 
--		a status-code of 150 (Failed Rec). 
--		For report "RadRecFailed.rdl"

-- =============================================
CREATE PROCEDURE [dbo].[sp_Monitoring_RadRecFailed]

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @NumCount int
	
	SELECT @NumCount =  Count(*)
						from
							[Entrada].[dbo].jobstatusa js,
							[Entrada].[dbo].clinics c,
							[Entrada].[dbo].jobs j
						where
							j.jobnumber=js.JobNumber and
							j.clinicid=c.clinicid and
							js.Status=150 and
							c.ClinicID in (40,45) and
							js.statusdate < getdate()-.1041

				
	IF @NumCount = 0
		BEGIN
			SELECT 1/0
		END
	ELSE
		BEGIN 
			SELECT @NumCount
		END
	
END	

GO
