SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[doSplitJob] (	
	@JobNumber  varchar(20),
	@NewJobNumber varchar(20),
	@SplitMode char(1),
	@JobType  varchar(50),
	@AlternateID varchar(50), 
	@MRN varchar(50), 
	@FirstName varchar(50), 
	@MI varchar(50), 
	@LastName varchar(50), 
	@Suffix varchar(50), 
	@DOB varchar(50), 
	@SSN varchar(50),  
	@Address1 varchar(50), 
	@Address2 varchar(50), 
	@City varchar(50), 
	@State varchar(50), 
	@Zip varchar(50), 
	@Phone varchar(50), 
	@Sex varchar(10) 
) AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			/* Increments job number by the new job number suffix in table JobNumbers */
			UPDATE [dbo].JobNumbers
			SET NumJobs = CONVERT(int, RIGHT(@NewJobNumber, 8))
			WHERE (JobDate = CONVERT(smalldatetime, LEFT(@NewJobNumber, 8), 111))
		
			
			/* Insert new child job editor in Jobs table */
			INSERT INTO [dbo].[Jobs] (
				 JobNumber, DictatorID, ClinicID, Location, AppointmentDate,
				 AppointmentTime, JobType, ContextName, Vocabulary, Stat, CC,
				 Duration, DictationDate, DictationTime, ReceivedOn, DueDate, 
				 ReturnedOn, CompletedOn, RecServer, EditorID, 
				 BilledOn, Amount, ParentJobNumber, DocumentStatus
		  ) SELECT @NewJobNumber, DictatorID, ClinicID, Location, AppointmentDate,
				 AppointmentTime, @JobType, ContextName, Vocabulary, Stat, CC,
				 Duration, DictationDate, DictationTime, ReceivedOn, NULL, 
				 NULL, NULL, RecServer, NULL, 
				 NULL, NULL, @JobNumber, NULL
			FROM [dbo].[Jobs]
			WHERE (JobNumber = @JobNumber)


			EXEC dbo.doUpdateJobDueDate @NewJobNumber, 'SplitJob'

			/* EXEC doUpdateNewVersionDataForJob @NewJobNumber */		
						
			/* Insert new patient for created job in Jobs_Patients table */
			IF (@SplitMode = 'P' OR @LastName <> '' OR @FirstName <> '')
				BEGIN
					INSERT INTO [dbo].[Jobs_Patients] (
						JobNumber, AlternateID, MRN, FirstName, MI, LastName, Suffix, 
						DOB, SSN, Address1, Address2, City, [State], Zip, Phone, Sex
				  ) VALUES ( 
						@NewJobNumber, @AlternateID, @MRN, @FirstName, @MI, @LastName, @Suffix, 
						@DOB, @SSN, @Address1, @Address2, @City, @State, @Zip, @Phone, @Sex
				  )
				END
			ELSE
			   BEGIN
	   				INSERT INTO [dbo].[Jobs_Patients] (
						JobNumber, AlternateID, MRN, FirstName, MI, LastName, Suffix, 
						DOB, SSN, Address1, Address2, City, [State], Zip, Phone, Sex)
					SELECT @NewJobNumber, AlternateID, MRN, FirstName, MI, LastName, Suffix, 
						   DOB, SSN, Address1, Address2, City, [State], Zip, Phone, Sex
					FROM [dbo].[Jobs_Patients]
					WHERE (JobNumber = @JobNumber)
			   END

    		/* Insert new Job on JobStatusA table with JobAvailable status derived from split operation */
			INSERT INTO [dbo].JobStatusA
			([JobNumber], [Status], [StatusDate], [Path])	
			SELECT @NewJobNumber, [dbo].ftGetStatusID('JobAvailable', 'Editor'), GETDATE(), [Path] 
			FROM [dbo].ftGetJobStatus(@JobNumber)
			
			/* Insert into JobTracking table JobAvailable status for new job derived from split operation */
		  INSERT INTO [dbo].[JobTracking]
			([JobNumber], [Status], [StatusDate], [Path])
		  SELECT [JobNumber], [Status], [StatusDate], [Path] 
		  FROM [dbo].JobStatusA
		  WHERE (JobNumber = @NewJobNumber)
				
			INSERT INTO [dbo].[Jobs_Custom]
		  ([JobNumber], [Custom1], [Custom2],[Custom3], [Custom4], [Custom5], [Custom6], [Custom7],[Custom8],[Custom9],[Custom10],
		   [Custom11],[Custom12],[Custom13],[Custom14],[Custom15],[Custom16],[Custom17],[Custom18],[Custom19],[Custom20],
		   [Custom21],[Custom22],[Custom23],[Custom24],[Custom25],[Custom26],[Custom27],[Custom28],[Custom29],[Custom30],
		   [Custom31],[Custom32],[Custom33],[Custom34],[Custom35],[Custom36],[Custom37],[Custom38],[Custom39],[Custom40],
		   [Custom41],[Custom42],[Custom43],[Custom44],[Custom45],[Custom46],[Custom47],[Custom48],[Custom49],[Custom50])
 			SELECT @NewJobNumber, [Custom1], [Custom2],[Custom3], [Custom4], [Custom5], [Custom6], [Custom7],[Custom8],[Custom9],[Custom10],
		   [Custom11],[Custom12],[Custom13],[Custom14],[Custom15],[Custom16],[Custom17],[Custom18],[Custom19],[Custom20],
		   [Custom21],[Custom22],[Custom23],[Custom24],[Custom25],[Custom26],[Custom27],[Custom28],[Custom29],[Custom30],
		   [Custom31],[Custom32],[Custom33],[Custom34],[Custom35],[Custom36],[Custom37],[Custom38],[Custom39],[Custom40],
		   [Custom41],[Custom42],[Custom43],[Custom44],[Custom45],[Custom46],[Custom47],[Custom48],[Custom49],[Custom50]
			FROM [dbo].[Jobs_Custom]
			WHERE (JobNumber = @JobNumber)
			
			
		INSERT INTO [dbo].[Jobs_Referring]
		([JobNumber],[PhysicianID],[FirstName],[MI],[LastName],[Suffix],[DOB],[SSN],[Sex],
		 [Address1],[Address2],[City],[State],[Zip],[Phone],[Fax],[ClinicName])
		SELECT @NewJobNumber,[PhysicianID],[FirstName],[MI],[LastName],[Suffix],[DOB],[SSN],[Sex],
			[Address1],[Address2],[City],[State],[Zip],[Phone],[Fax],[ClinicName]
			FROM [dbo].[Jobs_Referring]
			WHERE (JobNumber = @JobNumber)

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
	RETURN
END
GO
