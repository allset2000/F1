SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeClinic] (
	@ClinicID  [smallint],
	@ClinicName  [varchar]  (200),
	@ClinicCode  [varchar]  (20),
	@NumCharsPerLine  [smallint],
	@PageRate  [money],
	@LineRate  [money],
	@SecondRate  [money],
	@EditPageRate  [money],
	@EditLineRate  [money],
	@EditSecondRate  [money],
	@ClinicReviewEnabled  [bit],
	@ESignatureEnabled  [bit],
	@CloseDocuments  [bit],
	@NumDaysToClose  [smallint],
	@Active  [bit],
	@NumDictators  [smallint],
	@EnableTDD  [bit],
	@JobTag  [varchar]  (10),
	@PatientTag  [varchar]  (10)
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Clinics] WHERE ([ClinicID] = @ClinicID))
	 BEGIN
			INSERT INTO [dbo].[Clinics] (
				[ClinicID], [ClinicName], [ClinicCode], [NumCharsPerLine], [PageRate], [LineRate], [SecondRate],
				[EditPageRate], [EditLineRate], [EditSecondRate], [ClinicReviewEnabled], [ESignatureEnabled],
				[CloseDocuments], [NumDaysToClose], [Active], [NumDictators], [EnableTDD], [JobTag], [PatientTag] 
			) VALUES (
				@ClinicID, @ClinicName, @ClinicCode, @NumCharsPerLine, @PageRate, @LineRate, @SecondRate,
				@EditPageRate, @EditLineRate, @EditSecondRate, @ClinicReviewEnabled, @ESignatureEnabled,
				@CloseDocuments, @NumDaysToClose, @Active, @NumDictators, @EnableTDD, @JobTag, @PatientTag 
			)
	 END
ELSE 
	 BEGIN
		UPDATE [dbo].[Clinics] 
		 SET
			 [ClinicName] = @ClinicName ,
			 [ClinicCode] = @ClinicCode ,
			 [NumCharsPerLine] = @NumCharsPerLine ,
			 [PageRate] = @PageRate ,
			 [LineRate] = @LineRate ,
			 [SecondRate] = @SecondRate ,
			 [EditPageRate] = @EditPageRate ,
			 [EditLineRate] = @EditLineRate ,
			 [EditSecondRate] = @EditSecondRate ,
			 [ClinicReviewEnabled] = @ClinicReviewEnabled ,
			 [ESignatureEnabled] = @ESignatureEnabled ,
			 [CloseDocuments] = @CloseDocuments ,
			 [NumDaysToClose] = @NumDaysToClose ,
			 [Active] = @Active,
			 [NumDictators] = @NumDictators, 
			 [EnableTDD] = @EnableTDD ,
			 [JobTag] = @JobTag ,
			 [PatientTag] = @PatientTag  
		WHERE 
			([ClinicID] = @ClinicID) 
	END
GO
