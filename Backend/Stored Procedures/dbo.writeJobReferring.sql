SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeJobReferring] (
	@JobNumber  [varchar]  (20),
	@PhysicianID  [varchar]  (50),
	@FirstName  [varchar]  (50),
	@MI  [varchar]  (50),
	@LastName  [varchar]  (50),
	@Suffix  [varchar]  (50),
	@DOB  [varchar]  (50),
	@SSN  [varchar]  (50),
	@Sex  [varchar]  (10),
	@Address1  [varchar]  (50),
	@Address2  [varchar]  (50),
	@City  [varchar]  (50),
	@State  [varchar]  (50),
	@Zip  [varchar]  (50),
	@Phone  [varchar]  (20),
	@Fax  [varchar]  (50),
	@ClinicName  [varchar]  (100) 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Jobs_Referring] WHERE ([JobNumber] = @JobNumber))
   BEGIN
		INSERT INTO [dbo].[Jobs_Referring] (
			[JobNumber], [PhysicianID], [FirstName], [MI], [LastName],
			[Suffix], [DOB], [SSN], [Sex], [Address1], [Address2], [City],
			[State], [Zip], [Phone], [Fax], [ClinicName] 
		) VALUES (
			@JobNumber, @PhysicianID, @FirstName, @MI, @LastName,
			@Suffix, @DOB, @SSN, @Sex, @Address1, @Address2, @City,
			@State, @Zip, @Phone, @Fax, @ClinicName 
		)
   END
ELSE 
   BEGIN
		UPDATE [dbo].[Jobs_Referring] 
		 SET
			 [PhysicianID] = @PhysicianID ,
			 [FirstName] = @FirstName ,
			 [MI] = @MI ,
			 [LastName] = @LastName ,
			 [Suffix] = @Suffix ,
			 [DOB] = @DOB ,
			 [SSN] = @SSN ,
			 [Sex] = @Sex ,
			 [Address1] = @Address1 ,
			 [Address2] = @Address2 ,
			 [City] = @City ,
			 [State] = @State ,
			 [Zip] = @Zip ,
			 [Phone] = @Phone ,
			 [Fax] = @Fax ,
			 [ClinicName] = @ClinicName  
		WHERE 
			([JobNumber] = @JobNumber) 
END
GO
