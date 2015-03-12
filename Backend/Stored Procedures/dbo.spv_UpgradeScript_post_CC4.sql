SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 03/10/2015
-- Description: SP Used to store Backend data changes in the CC.4 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC4]
AS
BEGIN
--BEGIN #3084#
	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'JobNumber')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 0, N'JobNumber', 22, 15, 200, 22, 1, 20, 0, 0, N'')
		END
	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'NewJobNumber')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 1, N'NewJobNumber', 22, 15, 200, 22, 1, 20, 0, 0, N'')
		END
	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'SplitMode')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 2, N'SplitMode', 3, 1, 129, 3, 1, 1, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'JobType')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 3, N'JobType', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END
	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'AlternateID')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 4, N'AlternateID', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'MRN')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 5, N'MRN', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'FirstName')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 6, N'FirstName', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'MI')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 7, N'MI', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'LastName')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 8, N'LastName', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Suffix')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 9, N'Suffix', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'DOB')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 10, N'DOB', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'SSN')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 11, N'SSN', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Address1')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 12, N'Address1', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Address2')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 13, N'Address2', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'City')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 14, N'City', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'State')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 15, N'State', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Zip')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 16, N'Zip', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Phone')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 17, N'Phone', 22, 15, 200, 22, 1, 50, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Sex')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 18, N'Sex', 22, 15, 200, 22, 1, 10, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'Username')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 19, N'Username', 22, 15, 200, 22, 1, 20, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'DocDate')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 20, N'DocDate', 4, 12, 7, 6, 1, 0, 0, 0, N'')
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'doSplitJobForQA' and ParameterName = 'DocContent')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'doSplitJobForQA', 21, N'DocContent', 21, 100, 0, 0, 1, -1, 0, 0, N'')	
		END
--END #3084#
END
