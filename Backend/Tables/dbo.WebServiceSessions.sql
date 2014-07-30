CREATE TABLE [dbo].[WebServiceSessions]
(
[SessionGuid] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Token] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WebServiceSessions] ADD CONSTRAINT [PK_WebServiceSessions] PRIMARY KEY CLUSTERED  ([SessionGuid]) ON [PRIMARY]
GO
