SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeDictator] (
	@ClinicID  [smallint],
	@DictatorID  [varchar]  (50),
	@ClientUserID  [varchar]  (50),
	@DefaultLocation  [smallint],
	@FirstName  [varchar]  (50),
	@MI  [varchar]  (50),
	@LastName  [varchar]  (50),
	@Suffix  [varchar]  (50),
	@Initials  [varchar]  (50),
	@TemplatesFolder  [varchar]  (50),
	@Signature  [varchar]  (50),
	@User_Code  [varchar]  (50),
	@ForkAudio  [bit],
	@VREnabled  [bit],
	@Email  [varchar]  (50),
	@SignUpDate  [smalldatetime],
	@FirstDictation  [smalldatetime],
	@DictatorBillingDate  [smalldatetime],
	@NumCharsPerLine  [smallint],
	@PageRate  [money],
	@LineRate  [money],
	@SecondRate  [money],
	@EditPageRate  [money],
	@EditLineRate  [money],
	@EditSecondRate  [money],
	@ClinicReviewEnabled  [bit],
	@ESignatureEnabled  [bit],
	@ESignatureStamp  [varchar]  (200),
	@ESignatureLocation  [varchar]  (20),
	@CloseDocuments  [bit],
	@NumDaysToClose  [smallint],
	@DictatorIdOk  [int]
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Dictators] WHERE ([DictatorID] = @DictatorID))
   BEGIN
		INSERT INTO [dbo].[Dictators] (
			[ClinicID], [DictatorID], [ClientUserID], [DefaultLocation], [FirstName], [MI],
			[LastName], [Suffix], [Initials], [TemplatesFolder],[Signature], [User_Code], [ForkAudio],
			[VREnabled], [Email], [SignUpDate], [FirstDictation], [DictatorBillingDate],
			[NumCharsPerLine], [PageRate], [LineRate], [SecondRate], [EditPageRate], [EditLineRate],
			[EditSecondRate], [ClinicReviewEnabled], [ESignatureEnabled], [ESignatureStamp],
			[ESignatureLocation], [CloseDocuments], [NumDaysToClose], [DictatorIdOk] 
		) VALUES (
			@ClinicID, @DictatorID, @ClientUserID, @DefaultLocation, @FirstName, @MI,
			@LastName, @Suffix, @Initials, @TemplatesFolder, @Signature, @User_Code, @ForkAudio,
			@VREnabled, @Email, @SignUpDate, @FirstDictation, @DictatorBillingDate,
			@NumCharsPerLine, @PageRate, @LineRate, @SecondRate, @EditPageRate, @EditLineRate,
			@EditSecondRate, @ClinicReviewEnabled, @ESignatureEnabled, @ESignatureStamp,
			@ESignatureLocation, @CloseDocuments, @NumDaysToClose, @DictatorIdOk 
		)
   END
ELSE 
   BEGIN
			UPDATE [dbo].[Dictators] 
			 SET
				 [ClientUserID] = @ClientUserID ,
				 [DefaultLocation] = @DefaultLocation ,
				 [FirstName] = @FirstName ,
				 [MI] = @MI ,
				 [LastName] = @LastName ,
				 [Suffix] = @Suffix ,
				 [Initials] = @Initials ,
				 [TemplatesFolder] = @TemplatesFolder ,
				 [Signature] = @Signature ,
				 [User_Code] = @User_Code ,
				 [ForkAudio] = @ForkAudio ,
				 [VREnabled] = @VREnabled ,
				 [Email] = @Email ,
				 [SignUpDate] = @SignUpDate ,
				 [FirstDictation] = @FirstDictation ,
				 [DictatorBillingDate] = @DictatorBillingDate ,
				 [NumCharsPerLine] = @NumCharsPerLine ,
				 [PageRate] = @PageRate ,
				 [LineRate] = @LineRate ,
				 [SecondRate] = @SecondRate ,
				 [EditPageRate] = @EditPageRate ,
				 [EditLineRate] = @EditLineRate ,
				 [EditSecondRate] = @EditSecondRate ,
				 [ClinicReviewEnabled] = @ClinicReviewEnabled ,
				 [ESignatureEnabled] = @ESignatureEnabled ,
				 [ESignatureStamp] = @ESignatureStamp ,
				 [ESignatureLocation] = @ESignatureLocation ,
				 [CloseDocuments] = @CloseDocuments ,
				 [NumDaysToClose] = @NumDaysToClose ,
				 [DictatorIdOk] = @DictatorIdOk  
			WHERE 
				([DictatorID] = @DictatorID) 
	END
GO
