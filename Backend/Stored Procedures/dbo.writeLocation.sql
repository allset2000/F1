SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeLocation] (
		@ClinicID  [smallint],
		@LocationID  [smallint],
		@LocationName  [varchar]  (50),
		@Address1  [varchar]  (50),
		@Address2  [varchar]  (50),
		@City  [varchar]  (50),
		@State  [varchar]  (50),
		@Zip  [varchar]  (50),
		@Phone1  [varchar]  (50),
		@Phone2  [varchar]  (50),
		@Fax1  [varchar]  (50),
		@Fax2  [varchar]  (50),
		@Manager  [varchar]  (50),
		@ManagerPhone  [varchar]  (50),
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
		@NumDaysToClose  [smallint] 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Locations] WHERE ([ClinicID] = @ClinicID AND ([LocationID] = @LocationID)))
	 BEGIN
		INSERT INTO [dbo].[Locations] (
			[ClinicID], [LocationID], [LocationName], [Address1], [Address2], [City], [State], [Zip], [Phone1],
			[Phone2], [Fax1], [Fax2], [Manager], [ManagerPhone], [NumCharsPerLine], [PageRate], [LineRate],
			[SecondRate], [EditPageRate], [EditLineRate], [EditSecondRate], [ClinicReviewEnabled], [ESignatureEnabled],
			[CloseDocuments], [NumDaysToClose] 
		) VALUES (
			@ClinicID, @LocationID, @LocationName, @Address1, @Address2, @City, @State, @Zip, @Phone1,
			@Phone2, @Fax1, @Fax2, @Manager, @ManagerPhone, @NumCharsPerLine, @PageRate, @LineRate,
			@SecondRate, @EditPageRate, @EditLineRate, @EditSecondRate, @ClinicReviewEnabled, @ESignatureEnabled,
			@CloseDocuments, @NumDaysToClose 
		)
	 END
ELSE 
	 BEGIN
			UPDATE [dbo].[Locations] 
			 SET
				 [LocationName] = @LocationName ,
				 [Address1] = @Address1 ,
				 [Address2] = @Address2 ,
				 [City] = @City ,
				 [State] = @State ,
				 [Zip] = @Zip ,
				 [Phone1] = @Phone1 ,
				 [Phone2] = @Phone2 ,
				 [Fax1] = @Fax1 ,
				 [Fax2] = @Fax2 ,
				 [Manager] = @Manager ,
				 [ManagerPhone] = @ManagerPhone ,
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
				 [NumDaysToClose] = @NumDaysToClose  
			WHERE  (([ClinicID] = @ClinicID)  AND ([LocationID] = @LocationID))
	END
GO
