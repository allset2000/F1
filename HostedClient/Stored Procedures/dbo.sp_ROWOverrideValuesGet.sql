SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/17/2016  | sharif shaik        | get ROW Override Values for a jobs
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_ROWOverrideValuesGet '2014073000000015'
*/

CREATE PROCEDURE [dbo].[sp_ROWOverrideValuesGet] 
	@JobNumber varchar(100)
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT * FROM ROWOverrideValues WHERE JobNumber = @JobNumber

END
GO
