CREATE TABLE [dbo].[Security_Apps]
(
[uidAppUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_WebServicesSecurity_Apps_uidAppID] DEFAULT (newid()),
[sAppName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sAppDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Apps_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Apps_dteCreated] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_Security_Apps_dteModified] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
