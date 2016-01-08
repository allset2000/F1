SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender Ramadheni
-- Create date: 01/05/2016
-- Description:	This SP will validate whether the QBUsers list has access to patient's clinic
-- =============================================
CREATE PROCEDURE [dbo].[Sp_ValidateQBUsersClinicWithPatientClinic]
@PatientID int,
@QBUsersList nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	--Create a temp table to hold the QBUsers
	CREATE TABLE #QBUsers(QBUserID varchar(30))

	-- INSERT THE QBUSER ID'S INTO #QBUsers TEMP TABLE FROM COMMA SEPARATED LIST QBUsersList USING FUNCTION fnSplitString
	INSERT INTO #QBUsers(QBUserID) SELECT * From fnSplitString (@QBUsersList, ',') 
	
	DECLARE @ClinicID INT
	
	SET @ClinicID = (SELECT ClinicID FROM Patients WHERE PatientID = @PatientID)
	
	DECLARE @UserWithSameClinicCount INT

	SELECT @UserWithSameClinicCount = COUNT(DISTINCT X.UserID) FROM QuickBloxUsers QBU 
		 INNER JOIN Users U ON QBU.UserID = U.UserID
		 INNER JOIN UserClinicXref X ON U.UserID = X.UserID
		 INNER JOIN #QBUsers #QBU ON #QBU.QBUserID = QBU.QuickBloxUserID
	 WHERE X.ClinicID =  @ClinicID

	IF((SELECT COUNT(QBUserID) from #QBUsers) = @UserWithSameClinicCount )
		SELECT 1
	ELSE
		SELECT 0

	DROP TABLE #QBUsers

END
GO
