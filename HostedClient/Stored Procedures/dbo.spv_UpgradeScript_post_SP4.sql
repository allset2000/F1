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
END
GO
