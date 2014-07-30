CREATE TABLE [dbo].[Security_Clients]
(
[uidClientUID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_WebServicesSecurity_Clients_uidClientUID] DEFAULT (newid()),
[intClientID] [bigint] NULL,
[sClientCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sClientName] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Clients_bitActive] DEFAULT ((1)),
[dteCreate] [datetime] NOT NULL CONSTRAINT [DF_WebServicesSecurity_Clients_dteCreate] DEFAULT (getdate()),
[dteModified] [datetime] NOT NULL CONSTRAINT [DF_Security_Clients_dteModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
