SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 01/27/2016
-- Description:	This SP will return WorkList for selected search filter
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWorklistSearchReport] 
@clinicID smallint,
@PageNo smallint,
@SortColumnFromGrid varchar(50)= null,
@SortTypeFromGrid   varchar(50)= null,
@PageSize smallint,
@QueueID varchar(50) = null,
@JobType varchar(100) = null,
@Status varchar(50) = null,
@From varchar(50) = null,
@To varchar(50)= null,
@MRN varchar(50) = null,
@FirstName varchar(100) = null,
@LastName varchar(100) = null,
@TotalCount int Output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	
    
END
GO
