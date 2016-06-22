
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Narender
-- Create date: 05/21/2015
-- Description: SP Used to Save the User Search Preferences
-- =============================================

CREATE PROCEDURE [dbo].[sp_InsertAndUpdatePortalJobReportPreferences]
(
  @Operation SMALLINT,
  @userName VARCHAR(50),
  @dateField VARCHAR(50) = null,
  @range VARCHAR(50) = null,
  @from DATETIME = null,
  @to DATETIME = null,
  @jobType VARCHAR(50) = null,
  @jobStatus VARCHAR(50) = null,
  @dictatorID VARCHAR(50) = null,
  @mrn VARCHAR(50) = null,
  @firstName VARCHAR(50) = null,
  @lastName VARCHAR(50) = null,
  @isDeviceGenerated BIT = null,
  @cc BIT = null,
  @stat BIT = null,
  @selectedColumns VARCHAR(500) = null,
  @groupBy VARCHAR(50) = null,
  @resultsPerPage SMALLINT = null,
  @sortBy VARCHAR(50) = null,
  @sortType VARCHAR(50) = null,
  @reportName VARCHAR(300) = null,
  @id INT = null,
  @clinicId smallint= null,
  @isSaved BIT,
  @jobNumber VARCHAR(20) = null,
  @dictatorFirstName VARCHAR(20) = null,
  @dictatorLastName VARCHAR(20) = null,
  @newPrefID int output
)
AS
BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @newId SMALLINT
		IF @Operation = 1 --insert 
		BEGIN
			--Insert the Record into PortalJobReportPreferences table
			INSERT INTO PortalJobReportPreferences(UserID, DateField, [Range], [From], [To], JobType, JobStatus, DictatorID, MRN, FirstName, LastName,
			isDeviceGenerated, CC, STAT, SelectedColumns, GroupBy, ResultsPerPage, SortBy, SortType, ReportName, ClinicId, IsSaved,CreatedDate, UpdatedDate, JobNumber, DictatorFirstName, DictatorLastName )
			VALUES (@userName, @dateField, @range, @from, @to, @jobType, @jobStatus, @dictatorID, @mrn, @firstName, @lastName, @isDeviceGenerated,
			@cc, @stat, @selectedColumns, @groupBy, @resultsPerPage, @sortBy, @sortType, @reportName, @clinicId, @isSaved, GetDate(), GetDate(), @jobNumber, @dictatorFirstName, @dictatorLastName)

			-- this is to deleted all the temporarily saved reports of this user
			if(@isSaved =1 )
				Delete from PortalJobReportPreferences where UserID = @userName and IsSaved = 0;

			select @newPrefID=SCOPE_IDENTITY()
		END
		IF @Operation = 2 --Update
		BEGIN
			IF @id is not null
			BEGIN
				--Update the Record in PortalJobReportPreferences table
				UPDATE PortalJobReportPreferences
				SET DateField = @dateField, [Range] = @range, [From] = @from, [To] = @to, JobType = @jobType, JobStatus = @jobStatus, DictatorID = @dictatorID,
				MRN = @mrn, FirstName = @firstName, LastName = @lastName, isDeviceGenerated = @isDeviceGenerated, CC = @cc, STAT= @stat, SelectedColumns=  @selectedColumns, 
				GroupBy = @groupBy, ResultsPerPage = @resultsPerPage, SortBy = @sortBy, SortType = @sortType, ReportName = @reportName, ClinicId = @clinicId, UpdatedDate = GetDate()
				WHERE ID=@id AND UserID=@userName
				
				-- this is to deleted all the temporarily saved reports of this user
				Delete from PortalJobReportPreferences where UserID = @userName and IsSaved = 0;
			END
		END
   COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
		BEGIN
			ROLLBACK TRANSACTION
			DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END
END CATCH

GO
