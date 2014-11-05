
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_SP4]
AS
BEGIN
--BEGIN #2681# - SQL Changes to support Allscripts Integration
--Vivek - 10/31/2014
Update EHRVendors set Name = 'Allscripts PRO' Where Name = 'Allscripts'

if not exists(select 1 from EHRVendors where Name ='Allscripts TW')
	BEGIN
		Insert into EHRVendors values ('Allscripts TW', 0, 0)
	END
if not exists(select 1 from EHRVendors where Name ='Allscripts Sunrise')
	BEGIN
		Insert into EHRVendors values ('Allscripts Sunrise', 0, 0)
	END
--END #2681#
--BEGIN #2471#
if not exists(select * from Permissions where Code = 'FNC-CLINIC-ADDDOCUMENT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-CLINIC-ADDDOCUMNET','Function - Add Document to Clinic')
	END
if not exists(select * from Permissions where Code = 'FNC-CLINIC-EDITDOCUMENT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-CLINIC-EDITDOCUMENT','Function - Edit Document for Clinic')
	END
if not exists(select * from Permissions where Code = 'FNC-CLINIC-DOWNLOADDOCUMENT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-CLINIC-DOWNLOADDOCUMENT','Function - Download document for Clinic')
	END
if not exists(select * from Permissions where Code = 'FNC-CLINIC-DELETEDOCUMENT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-CLINIC-DELETEDOCUMENT','Function - Delete document for Clinic')
	END
--END #2471#
--BEGIN #1943#
if not exists(select * from Permissions where Code = 'TAB-EDITORS')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('TAB-EDITORS','Tab - Editors')
	END
if not exists(select * from Permissions where Code = 'FNC-EDITORS-ADD')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-EDITORS-ADD','Function - Add Editors')
	END
if not exists(select * from Permissions where Code = 'FNC-EDITORS-EDIT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-EDITORS-EDIT','Function - Edit Editors')
	END
--END #1943#
--BEGIN #1945#
if not exists(select * from Permissions where Code = 'TAB-BACKEND-COMPANIES')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('TAB-BACKEND-COMPANIES','Tab - Backend Companies')
	END
if not exists(select * from Permissions where Code = 'FNC-BACKENDCOMPANIES-ADD')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-BACKENDCOMPANIES-ADD','Function - Add Backend Companies')
	END
if not exists(select * from Permissions where Code = 'FNC-BACKENDCOMPANIES-EDIT')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-BACKENDCOMPANIES-EDIT','Function - Edit Backend Companies')
	END
--END #1945#
--BEGIN #1944#
if not exists(select * from Permissions where Code = 'FNC-EDITORS-EDITPAY')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-EDITORS-EDITPAY','Function - Edit Editors Pay')
	END
if not exists(select * from Permissions where Code = 'FNC-EDITORS-VIEWEDITORPAY')
	BEGIN
		INSERT INTO Permissions(Code, Name) values('FNC-EDITORS-VIEWEDITORPAY','Function - View Editors Pay')
	END
--END #1944#
END
GO
