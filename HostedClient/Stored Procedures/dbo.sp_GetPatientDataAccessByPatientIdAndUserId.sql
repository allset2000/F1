SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 02/20/2015
	Version: 1.0
	Details: SP used to pull a patient data access by patient Id and user id
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script was changed?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_GetPatientDataAccessByPatientIdAndUserId] (
	@PatientID INT,
	@UserID INT
)
AS 
BEGIN
	SELECT pda.PatientDataAccessID, pda.MessageThreadID, pda.UserID, pda.IsPermited, pda.CreatedDate, pda.UpdatedDate
	FROM [dbo].[PatientDataAccess] AS pda INNER JOIN [dbo].[MessageThreads] AS mt ON pda.MessageThreadID = mt.MessageThreadID
	WHERE mt.PatientID = @PatientID AND
	      pda.UserID = @UserID 
END
GO
