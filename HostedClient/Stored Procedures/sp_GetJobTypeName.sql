
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tamojit Chakraborty
-- Create date: 12/3/2015
-- Description:	Check if the job type name already exist
-- =============================================
CREATE PROCEDURE sp_GetJobtypeName 
	-- Add the parameters for the stored procedure here
	@jobtypename varchar(500)  
AS
BEGIN


--This variable reurn 1 or zero to the service
-- If no jobtype name is found then this variable will be set to 0(false) else to 1(true)
declare @jobtypecounter as bit 
if exists(SELECT Top(1) *
      FROM [EntradaHostedClient].[dbo].[JobTypes] Where Name=@jobtypename) 

	  set @jobtypecounter=1

	  else

	  set @jobtypecounter=0

	

	  select @jobtypecounter as JobTypeNameExists
	
END
GO
