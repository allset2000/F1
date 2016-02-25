
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spv_UpgradeScript_Post_E2]
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_post_E2
--X
--X AUTHOR: Santhosh
--X
--X DESCRIPTION: SP Used to store all data changes in the E.2 release
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   1    | 27-Jan-2016  | Santhosh                | #735 - Adding Multiple Providers and Multiple JobTypes while sending Notifications
--X   2    | 25-FRB-2016  | Narender				| #731 - Script to insert DB parameters to user SP from Backend WS
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	/*735*/
	INSERT INTO ClinicMessageRuleDictators 
	SELECT MessageRuleId, DictatorID FROM ClinicsMessagesRules WHERE ISNULL(DictatorID,'') <> ''

	INSERT INTO ClinicMessageRuleJobTypes
	SELECT MessageRuleId, JobType FROM ClinicsMessagesRules WHERE ISNULL(JobType,'') <> ''

	INSERT INTO ClinicMessageRuleUsers
	SELECT MessageRuleId, UserId FROM ClinicsMessagesRules WHERE ISNULL(UserId,'') <> ''
	/*735*/

	-- #731 start

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'getJobSTATFromHitory' and ParameterName = 'JobNumber')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'getJobSTATFromHitory', 0, N'JobNumber', 22, 15, 200, 22, 1, 20, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'JobNumber')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 0, N'JobNumber', 22, 15, 200, 22, 1, 20, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'MRN')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 1,'MRN',22, 15, 200, 22, 1, 20, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'JobType')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 2, 'JobType', 22, 15, 200, 22, 1, 100, 0, 0, N'')
		END
		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'CurrentStatus')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 3, 'CurrentStatus', 16, 2, 2,	27,	1, 0, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'UserId')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 4,'UserId',22, 15, 200, 22, 1, 40, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'FirstName')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 5,'FirstName',22,	15,	200,22,	1,20, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'MI')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 6,'MI',22,15,200,	22,	1,20,0,	0, N'')
		END
		
		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'LastName')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 7,'LastName',	22,	15,	200,22,	1,20, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'writeSTATHistory' and ParameterName = 'STAT')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'writeSTATHistory', 8, 'STAT', 2, 16, 11, 0, 1, 0, 0, 0, N'')
		END

	-- #731 end
END

GO
