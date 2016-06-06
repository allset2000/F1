SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spv_UpgradeScript_Post_F2]
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: spv_UpgradeScript_post_F2
--X
--X AUTHOR: Sharif Shaik
--X
--X DESCRIPTION: SP Used to store all data changes in the F.2 release
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
--X  VER   |    DATE      |  BY						|	Ticket#		|	COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 29-Mar-2016  | Sharif Shaik			|				|	Initial Design
--X   1    | 19-May-2016  | Santhosh                |    #281       |   Editor "Queue Manager- Assign/release jobs for other users
--X   2    | 24-May-2016  | Santhosh                |    #3584      |   Allowing Editors to send jobs directly to CR without having to go through QA
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
AS
BEGIN
	
	--#281#
		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryGetQueuesByCompanyId' and ParameterName = 'CompanyId')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'qryGetQueuesByCompanyId', 0, N'CompanyId', 8, 3, 3, 28, 1, 0, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryGetEditorsByQueueId' and ParameterName = 'QueueId')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'qryGetEditorsByQueueId', 0, N'QueueId', 8, 3, 3, 28, 1, 0, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryGetJobsByQueueId' and ParameterName = 'QueueId')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'qryGetJobsByQueueId', 0, N'QueueId', 8, 3, 3, 28, 1, 0, 0, 0, N'')
		END

		IF NOT EXISTS(select * from DbQueryParameters where QueryName = 'qryGetJobsByQueueId' and ParameterName = 'IsAvailableJobs')
		BEGIN
			INSERT [dbo].[DbQueryParameters] ([QueryName], [ParameterIndex], [ParameterName], [ParameterSqlType], [ParameterMySqlType], [ParameterOleDbType], 
			[ParameterOracleType], [ParameterDirection], [ParameterSize], [ParameterScale], [ParameterPrecision], [ParameterDefaultValue]) 
			VALUES (N'qryGetJobsByQueueId', 1, N'IsAvailableJobs', 2, 16, 11, 0, 1, 0, 0, 0, N'')
		END
	--end #281#

	--#3584#
		IF NOT EXISTS(SELECT 1 FROM WorkFlowRules WHERE WorkFlowModelId = 202 AND EventTag = 'ReturnJobToCR' AND FromStateId = 500 AND ToStateId = 510)
		BEGIN
			INSERT INTO WorkFlowRules 	
			VALUES ((SELECT MAX(WorkFlowRuleId) FROM WorkFlowRules) + 1, 202, 'ReturnJobToCR', 500, 510, '', '', '', 0, 1, GETDATE(), 'A')
		END

		IF NOT EXISTS(SELECT 1 FROM WorkFlowRules WHERE WorkFlowModelId = 200 AND EventTag = 'ReturnJobToCR' AND FromStateId = 500 AND ToStateId = 510)
		BEGIN
			INSERT INTO WorkFlowRules 	
			VALUES ((SELECT MAX(WorkFlowRuleId) FROM WorkFlowRules) + 1, 200, 'ReturnJobToCR', 500, 510, '', '', '', 0, 1, GETDATE(), 'A')
		END
	--#3584#

END /* End of the SP */

GO
