SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ins_upd_referring]
	@ClinicID smallint,
	@PhysicianID varchar(50),
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
	@SSN varchar(11),
	@Phone1 varchar(25),
	@Phone2 varchar(25),
	@Fax1 varchar(25),
	@Fax2 varchar(25)
AS
BEGIN
UPDATE ReferringPhysicians
SET
	PhysicianID = @PhysicianID,
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
	SSN = @SSN,
	Phone1 = @Phone1,
	Phone2 = @Phone2,
	Fax1 = @Fax1,
	Fax2 = @Fax2
WHERE ClinicID = @ClinicID and PhysicianID = @PhysicianID

IF @@ROWCOUNT = 0
	BEGIN
		Insert into ReferringPhysicians (ClinicID, PhysicianID, FirstName, MI, LastName, Suffix, Gender, Address1, Address2, City, State, Zip, DOB, SSN, Phone1, Phone2, Fax1, Fax2)
		VALUES
		(@ClinicID, @PhysicianID, @FirstName, @MI, @LastName, @Suffix, @Gender, @Address1, @Address2, @City, @State, @Zip, @DOB, @SSN, @Phone1, @Phone2, @Fax1, @Fax2)	
	END


END
GO
