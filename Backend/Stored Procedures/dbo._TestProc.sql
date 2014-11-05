
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[_TestProc] 
	-- Add the parameters for the stored procedure here blah
	@JobNumber varchar(20)
AS

Select top 100 * from Entrada.dbo.jobs



GO
