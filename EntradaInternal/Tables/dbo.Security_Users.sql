CREATE TABLE [dbo].[Security_Users]
(
[uidUserUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Table_1_uidClientUID] DEFAULT (newid()),
[sLastName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sFirstName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Users_bitActive] DEFAULT ((1)),
[sUserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sPwd] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[intDefaultSecLevel] [int] NOT NULL CONSTRAINT [DF_Security_Users_intDefaultSecLevel] DEFAULT ((1)),
[intDepartmentID] [int] NULL,
[dteCreate] [datetime] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Users_dteCreate] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_Security_Users_dteModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
