SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writePatient] (
	@PatientId  [int],
	@JobNumber  [varchar]  (20),
	@AlternateID  [varchar]  (50),
	@MRN  [varchar]  (50),
	@FirstName  [varchar]  (50),
	@MI  [varchar]  (50),
	@LastName  [varchar]  (50),
	@Suffix  [varchar]  (50),
	@DOB  [varchar]  (50),
	@SSN  [varchar]  (50),
	@Address1  [varchar]  (100),
	@Address2  [varchar]  (100),
	@City  [varchar]  (50),
	@State  [varchar]  (50),
	@Zip  [varchar]  (50),
	@Phone  [varchar]  (50),
	@Sex  [varchar]  (10),
	@AppointmentId  [int] 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[Jobs_Patients] WHERE ([JobNumber] = @JobNumber))
   BEGIN
		INSERT INTO [dbo].[Jobs_Patients]
		( [JobNumber], [AlternateID], [MRN], [FirstName], [MI], [LastName], 
		  [Suffix], [DOB], [SSN], [Address1], [Address2], [City],
		  [State], [Zip], [Phone], [Sex], [PatientId], [AppointmentId]				
		) VALUES (
			@JobNumber, @AlternateID, @MRN, @FirstName, @MI, @LastName,
			@Suffix, @DOB, @SSN, @Address1, @Address2, @City,
			@State, @Zip, @Phone, @Sex, @PatientId, @AppointmentId 
		)
   END
ELSE 
   BEGIN
	UPDATE [dbo].[Jobs_Patients] 
	 SET
		 [PatientId] = @PatientId , 
		 [AlternateID] = @AlternateID ,
		 [MRN] = @MRN ,
		 [FirstName] = @FirstName ,
		 [MI] = @MI ,
		 [LastName] = @LastName ,
		 [Suffix] = @Suffix ,
		 [DOB] = @DOB ,
		 [SSN] = @SSN ,
		 [Address1] = @Address1 ,
		 [Address2] = @Address2 ,
		 [City] = @City ,
		 [State] = @State ,
		 [Zip] = @Zip ,
		 [Phone] = @Phone ,
		 [Sex] = @Sex ,
		 [AppointmentId] = @AppointmentId
	WHERE 
		([JobNumber] = @JobNumber)
END
GO
