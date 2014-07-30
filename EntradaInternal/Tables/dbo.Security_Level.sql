CREATE TABLE [dbo].[Security_Level]
(
[intSecurityLevelID] [int] NOT NULL IDENTITY(1, 1),
[sSecurityLevelName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sSecurityLevelDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_Security_Level_dteCreated] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
