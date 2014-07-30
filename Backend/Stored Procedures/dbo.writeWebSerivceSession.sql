SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeWebSerivceSession] (
	@DbSessionId  varchar(128),
	@DbUserId  varchar(50),
	@DbuserType  char(1),
	@DbToken  varchar(100),
	@DbEmail  varchar(100),
	@DbStartTime datetime
) AS
Begin
	INSERT INTO [dbo].[WebServiceSessions] ( [SessionGuid], [UserID], [userType], [Token], [Email],[StartTime])
		 VALUES (@DbSessionId, @DbUserId, @DbuserType, @DbToken, @DbEmail,@DbStartTime)
	
END
GO
