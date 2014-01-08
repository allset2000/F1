SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_patient]
	@ClinicID smallint,
	@MRN varchar(50), 
	@AlternateID varchar(50),
	@FirstName varchar(100),
	@MI varchar(100),
	@LastName varchar(100),
	@Suffix varchar(100),
	@Gender varchar(5),
	@Address1 varchar(100),
	@Address2 varchar(100),
	@City varchar(100),
	@State varchar(4),
	@Zip varchar(10),
	@DOB varchar(20),
	@Phone1 varchar(25),
	@Phone2 varchar(25),
	@Fax1 varchar(25),
	@Fax2 varchar(25)


AS
BEGIN

UPDATE Patients
SET
	MRN = @MRN,
	AlternateID = @AlternateID,
	FirstName = @FirstName,
	MI = @MI,
	LastName = @LastName,
	Suffix = @Suffix,
	Gender = @Gender,
	Address1 = @Address1,
	Address2 = @Address2,
	City = @City,
	State = @State,
	Zip = @Zip,
	DOB = @DOB,
	Phone1 = @Phone1,
	Phone2 = @Phone2,
	Fax1 = @Fax1,
	Fax2 = @Fax2
WHERE ClinicID = @ClinicID and MRN = @MRN

IF @@ROWCOUNT = 0
	BEGIN
		Insert into Patients (ClinicID, MRN, AlternateID, FirstName, MI, LastName, Suffix, Gender, Address1, Address2, City, State, Zip, DOB, Phone1, Phone2, Fax1, Fax2)
		VALUES
		(@ClinicID, @MRN, @AlternateID, @FirstName, @MI, @LastName, @Suffix, @Gender, @Address1, @Address2, @City, @State, @Zip, @DOB, @Phone1, @Phone2, @Fax1, @Fax2)	
	END


END
GO
