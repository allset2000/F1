SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ftGetClinicId] (
  @ClinicName varchar(200)
)
RETURNS int
AS
BEGIN
	DECLARE @ClinicId smallint

	SELECT @ClinicId = ClinicId
	FROM Clinics
	WHERE (ClinicName = @ClinicName)

	IF (@ClinicId IS NULL)
	  BEGIN
		SET @ClinicId = -1
	  END
	  
    RETURN @ClinicId
END

GO
