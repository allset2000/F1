SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************
** File:  spUpdateDictations.sql
** Name:  spUpdateDictations
** Desc:  update the record in Dictations table
** Auth:  Suresh
** Date:  13/Feb/2015
**************************
** Change History
**************************
** PR   Date	    Author  Description	
** --   --------   -------   ------------------------------------
** 
*******************************/
CREATE PROCEDURE [dbo].[spUpdateDictations]
(	
	@vsmintStatus	SMALLINT,
	@vvcrFileName	VARCHAR(255),
	@vintDictationID	INT
)	
AS
BEGIN
	UPDATE Dictations
	SET Status=@vsmintStatus,FileName=@vvcrFileName,UpdatedDateInUTC=GETUTCDATE()
	WHERE DictationID = @vintDictationID

END
GO
