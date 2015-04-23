-- =============================================
-- Author: Santhosh
-- Create date: 04/23/2015
-- Description: SP used to get UnusedNextgenEHRDictatorIDs
CREATE PROCEDURE [dbo].[getUnusedNextgenEHRDictatorIDs] 
(
	@iClinicID INT = -1
)
AS
BEGIN
	DECLARE @ClinicID INT
	SET @ClinicID = @iClinicID
	SELECT 
		X.Attending as 'ResourceID'
		, X.AttendingFirst + ' ' + X.AttendingLast as 'ResourceName' 
	from 
		(SELECT DISTINCT Attending,AttendingFirst, AttendingLast FROM Schedules s 
			WHERE ClinicID = @ClinicID 
				AND Attending NOT IN (SELECT DISTINCT EHRProviderID FROM Dictators WHERE ClinicID = @ClinicID)) X  
	ORDER BY X.AttendingLast
END
GO


