/****** Object:  StoredProcedure [dbo].[sp_IsJobTypeNameUnique]    Script Date: 12/21/2015 7:52:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Tamojit Chakraborty
-- Create date: 12/3/2015
-- Description:	Check if the job type name already exist
-- =============================================
CREATE PROCEDURE [dbo].[sp_IsJobTypeNameUnique] 
	-- Add the parameters for the stored procedure here
	@jobtypename varchar(100) , 

	@clinicid   smallint
AS
BEGIN


--This variable reurn 1 or zero to the service
-- If no jobtype name is found then this variable will be set to 1(true) else to 0(false)
declare @isjobtypenameunique as bit =1


SELECT @isjobtypenameunique=0

      FROM JobTypes Where Name=@jobtypename and clinicid=@clinicid

	  select @isjobtypenameunique as IsJobTypeNameUnique
	
END
GO


