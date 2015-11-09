
/****** Object:  StoredProcedure [dbo].[sp_GetAllROWLookups]    Script Date: 8/17/2015 12:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author: Santhosh 
-- Create date: 07/07/2015  
-- Description: SP used to get all ROW Lookups to display in AdminConsole
-- =============================================  
CREATE PROCEDURE [dbo].[sp_GetAllROWLookups]
AS
BEGIN
	SELECT L.ClinicID, L.Category, L.[Key], L.Value, C.ClinicName, C.ClinicCode
	FROM ROW_Lookup L
	INNER JOIN Clinics C ON C.ClinicID = L.ClinicID

END
GO


