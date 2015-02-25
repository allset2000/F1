SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Narender
-- Create date: 02/19/2015
-- Description: SP Used to store Backend data changes in the CC.2 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_CC2]
AS
BEGIN
--BEGIN #2581#
IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'getFullDocumentWithJobNumberAndStatus' and ParameterIndex = 0 and ParameterName = 'JobNumber')
	BEGIN
		INSERT INTO [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
		[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
		VALUES (N'getFullDocumentWithJobNumberAndStatus', 0, N'JobNumber', 22, 15, 200, 22, 1, 20, 0, 0, N'')
	END
IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'getFullDocumentWithJobNumberAndStatus' and ParameterIndex = 1 and ParameterName = 'Status'
			and ParameterSqlType = 16 and ParameterSize = 0)
	BEGIN
		INSERT INTO [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
		[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
		VALUES (N'getFullDocumentWithJobNumberAndStatus', 1, N'Status', 16, 2, 2, 27, 1, 0, 0, 0, N'')
	END
IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'getFullDocumentWithJobNumberAndStatus' and ParameterIndex = 2 and ParameterName = 'DocID')
	BEGIN
		INSERT INTO [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
		[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
	 VALUES (N'getFullDocumentWithJobNumberAndStatus', 2, N'DocID', 22, 15, 200, 22, 1, 20, 0, 0, N'')
	 END
--END #2581#
END
