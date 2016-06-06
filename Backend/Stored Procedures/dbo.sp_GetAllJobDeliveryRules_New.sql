SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- exec sp_GetAllJobDeliveryRules_New null,null,null,null,null,1,'ClinicName','Ascending',10
 
 
 CREATE PROCEDURE [dbo].[sp_GetAllJobDeliveryRules_New]
 @ClinicID int ,
 @RuleDictator varchar(100),
 @JobType varchar(100),
 @RuleTypeID int,
 @DeliveryRuleName varchar(100),
 @PageNo smallint,
 @SortColumnFromGrid varchar(50)= null,
 @SortTypeFromGrid   varchar(50)= null,
 @PageSize smallint=10
 --@TotalCount int output
AS
BEGIN
			CREATE TABLE #SearchResults(DeliveryRuleID int ,RuleClinicID int,RuleLocationID varchar(50) NULL,RuleDictator varchar(50) NULL,JobType varchar(50) NULL
									   ,Method int,MethodName varchar(50) NULL,DeliveryRuleName varchar(50) NULL,AvoidRedelivery bit NULL
									   ,ClinicName varchar(200) NULL,LocationName varchar(50) NULL)
			insert into #SearchResults 
				SELECT 
					D.RuleID 
					, ISNULL(D.ClinicID,'') 
					, ISNULL(D.LocationID,'0') 
					, ISNULL(D.DictatorName,'') 
					, ISNULL(D.JobType,'') AS JobType
					, D.Method
					, (CASE WHEN D.Method = 1100 THEN 'Image'
										WHEN D.Method = 100 THEN 'Full Document'
										WHEN D.Method = 300 THEN 'NextGen Doc'
										WHEN D.Method = 600 THEN 'NextGen Note'
										WHEN D.Method = 400 THEN 'NextGenDD'
										WHEN D.Method = 1000 THEN 'NextGen Image'
										WHEN D.Method = 200 THEN 'HL7'
										WHEN D.Method = 900 THEN 'EL Hosted(900)'
										WHEN D.Method = 0 THEN 'No Delivery' END) AS 'MethodName'
					, ISNULL(D.RuleName,'') 
					, D.AvoidRedelivery
					, C.ClinicName
					, ISNULL(L.LocationName,'')
				FROM JobDeliveryRules D
				INNER JOIN Clinics C ON C.ClinicID = D.ClinicID
				LEFT JOIN Locations L ON L.LocationID = ISNULL(D.LocationID,0) AND L.ClinicID = D.ClinicID
				WHERE 
				(ISNULL(@ClinicID,0)=0 or D.ClinicID = @ClinicID) 
				and (ISNULL(@RuleDictator,'')='' or D.DictatorName = @RuleDictator) 
				and (@JobType is null or @JobType='' or D.JobType = @JobType)
				and (ISNULL(@RuleTypeID,'')='' or D.Method = @RuleTypeID)
				and (ISNULL(@DeliveryRuleName,'')='' or D.RuleName = @DeliveryRuleName)
				--ORDER BY D.RuleID DESC

				SELECT *,COUNT(*) OVER()  as TotalCount 
				FROM #SearchResults ORDER BY 
					  CASE WHEN @SortTypeFromGrid = 'Ascending' THEN 
								CASE @SortColumnFromGrid 
								WHEN 'RuleDictator'   THEN RuleDictator 
								WHEN 'ClinicName' THEN ClinicName 								
								WHEN 'RuleClinicID'   THEN CAST(RuleClinicID AS VARCHAR) 
								WHEN 'LocationName'   THEN LocationName 
								WHEN 'DeliveryRuleName'   THEN DeliveryRuleName 
								WHEN 'JobType'   THEN JobType 
								WHEN 'MethodName'   THEN MethodName 
								END
							END,
							CASE WHEN @SortTypeFromGrid = 'Descending' THEN
								CASE @SortColumnFromGrid 
								WHEN 'RuleDictator'   THEN RuleDictator 
								WHEN 'ClinicName'   THEN ClinicName
								WHEN 'RuleClinicID'   THEN CAST(RuleClinicID AS VARCHAR)  
								WHEN 'LocationName'   THEN LocationName 
								WHEN 'DeliveryRuleName'   THEN DeliveryRuleName 
								WHEN 'JobType'   THEN JobType 
								WHEN 'MethodName'   THEN MethodName 
								END
							END DESC
				
					  OFFSET (@PageNo - 1) * @PageSize ROWS
					  FETCH NEXT @PageSize ROWS ONLY

		------ execute same SQL to get the total count
	 --   Select @TotalCount = COUNT(DeliveryRuleID)
		--FROM #SearchResults
			
		DROP TABLE #SearchResults
	
END


GO
