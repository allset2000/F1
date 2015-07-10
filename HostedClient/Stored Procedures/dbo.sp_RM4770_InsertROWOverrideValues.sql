SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 4/30/15
-- Description: Temp SP used to inserts values into the ROWOverrideValues table 
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM4770_InsertROWOverrideValues] 
(
@Jobnumber varchar(20),
@FieldID smallint,
@Value nvarchar(100)
) 

AS 

  INSERT INTO [ROWOverrideValues]
  (JobNumber, FieldID, Value)
  VALUES (@Jobnumber, @FieldID, @Value)



GO
