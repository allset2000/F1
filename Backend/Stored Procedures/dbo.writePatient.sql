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
		-- **This block is to save record in Job_History table**		
		DECLARE @CurrentStatus INT
		DECLARE @PreviousMRN VARCHAR(50)
		DECLARE @PreviousFirstName VARCHAR(50)
		DECLARE @PreviousMI VARCHAR(50)
		DECLARE @PreviousLastName VARCHAR(50)
		DECLARE @PreviousDOB VARCHAR(50)		

		-- Getting Job Status		
		SELECT @CurrentStatus = STATUS FROM JobStatusA WHERE jobnumber = @JobNumber
		IF(@CurrentStatus is NULL )
			SELECT @CurrentStatus = STATUS FROM JobStatusB WHERE jobnumber = @JobNumber

		-- if any demographics value is changed then track that previous value. 
		SELECT 
			@PreviousMRN = CASE WHEN MRN <> @MRN THEN MRN ELSE NULL END,
			@PreviousFirstName = CASE WHEN FirstName <> @FirstName THEN FirstName ELSE NULL END,
			@PreviousMI = CASE WHEN MI <> @MI THEN MI ELSE NULL END,
			@PreviousLastName = CASE WHEN LastName <> @LastName THEN LastName ELSE NULL END,
			@PreviousDOB = CASE WHEN DOB <> @DOB THEN DOB ELSE NULL END
		FROM jobs_patients
		WHERE JOBNUMBER = @JobNumber
		IF (@PreviousMRN IS NOT NULL OR @PreviousFirstName IS NOT NULL OR @PreviousMI IS NOT NULL OR @PreviousLastName IS NOT NULL OR @PreviousDOB IS NOT NULL)
		BEGIN
			INSERT INTO Job_History
			(JobNumber, MRN, CurrentStatus, FirstName, MI, LastName, DOB, HistoryDateTime)
			VALUES
			(@JobNumber, @PreviousMRN, @CurrentStatus, @PreviousFirstName, @PreviousMI, @PreviousLastName, @PreviousDOB, GETDATE())
		END
		-- ****
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
