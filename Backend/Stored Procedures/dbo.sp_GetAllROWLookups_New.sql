SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE PROCEDURE [dbo].[sp_GetAllROWLookups_New]
 @ClinicID int ,
 @ClinicCode varchar(100),
 @PageNo smallint,
 @SortColumnFromGrid varchar(50)= null,
 @SortTypeFromGrid   varchar(50)= null,
 @PageSize smallint=10
 --@TotalCount int output
AS
BEGIN
--IF(@CLINICCODE IS NOT NULL)
--BEGIN
--SET @ClinicID=(SELECT TOP 1 ClinicID from Clinics where ClinicCode=@ClinicCode)
--END
CREATE TABLE #SearchResults(ClinicID smallint ,Category varchar(100) NULL,[Key] varchar(100) NULL,[Value] varchar(100) NULL
		                   ,ClinicName varchar(200) NULL,ClinicCode varchar(20) NULL)
INSERT INTO #SearchResults
	SELECT L.ClinicID, L.Category, L.[Key], L.[Value], C.ClinicName, C.ClinicCode
	FROM ROW_Lookup L
	INNER JOIN Clinics C ON C.ClinicID = L.ClinicID
	WHERE 
	(ISNULL(@ClinicID,0)=0 or L.ClinicID = @ClinicID)
	                   AND 
	(ISNULL(@ClinicCode,'')='' or L.ClinicID = (SELECT TOP 1 ClinicID from Clinics where ClinicCode=@ClinicCode))
	 
	
	SELECT *,COUNT(*) OVER()  as TotalCount
	FROM #SearchResults
		  
		  ORDER BY
		  CASE WHEN @SortTypeFromGrid = 'Ascending' THEN 
					CASE @SortColumnFromGrid 
					WHEN 'Category' THEN Category 
					WHEN 'Key'   THEN [Key] 
					WHEN 'Value'   THEN [Value] 
					WHEN 'ClinicName'   THEN ClinicName 
					WHEN 'ClinicCode'   THEN ClinicCode 
					END
				END,
				CASE WHEN @SortTypeFromGrid = 'Descending' THEN
					CASE @SortColumnFromGrid 
					WHEN 'Category' THEN Category 
					WHEN 'Key'   THEN [Key] 
					WHEN 'Value'   THEN [Value] 
					WHEN 'ClinicName'   THEN ClinicName 
					WHEN 'ClinicCode'   THEN ClinicCode  
					END
				END DESC
				
		  OFFSET (@PageNo - 1) * @PageSize ROWS
		  FETCH NEXT @PageSize ROWS ONLY

		------ execute same SQL to get the total count
	 --   Select @TotalCount = COUNT(*)
		--FROM #SearchResults
			
		DROP TABLE #SearchResults
	
	END
GO
