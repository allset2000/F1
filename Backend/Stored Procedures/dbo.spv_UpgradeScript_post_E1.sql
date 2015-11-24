SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Suresh
-- Create date: 24/11/2015
-- Description: SP Used to store Backend data changes in the E.1 release
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_D2]
AS
BEGIN
--BEGIN #746
	-- Data for [DbQueryParameters]
	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryspGetEditorsForJob' and ParameterName = 'vintClinicId')
		BEGIN
			INSERT INTO DbQueryParameters (QueryName,ParameterIndex,ParameterName,ParameterSqlType,ParameterMySqlType,ParameterOleDbType,ParameterOracleType,ParameterDirection,ParameterSize,ParameterScale,ParameterPrecision,ParameterDefaultValue)
									VALUES('qryspGetEditorsForJob', 0,'vintClinicId',8,3,3,28,1,0,0,0,'')	
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryspGetEditorsForJob' and ParameterName = 'vintDictatorId')
		BEGIN
			INSERT INTO DbQueryParameters (QueryName,ParameterIndex,ParameterName,ParameterSqlType,ParameterMySqlType,ParameterOleDbType,ParameterOracleType,ParameterDirection,ParameterSize,ParameterScale,ParameterPrecision,ParameterDefaultValue)
									VALUES('qryspGetEditorsForJob', 1,'vintDictatorId',8,3,3,28,1,0,0,0,'')	
		END

	IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryspGetEditorsForJob' and ParameterName = 'vvcrJobsFilter')
		BEGIN
			INSERT INTO DbQueryParameters (QueryName,ParameterIndex,ParameterName,ParameterSqlType,ParameterMySqlType,ParameterOleDbType,ParameterOracleType,ParameterDirection,ParameterSize,ParameterScale,ParameterPrecision,ParameterDefaultValue)
									VALUES('qryspGetEditorsForJob', 2,'vvcrJobsFilter',22,15,200,22,1,100,0,0,'')
		END
--END #746
END

GO

