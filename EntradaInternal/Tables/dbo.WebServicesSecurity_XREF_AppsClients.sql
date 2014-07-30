CREATE TABLE [dbo].[WebServicesSecurity_XREF_AppsClients]
(
[intXref_AppsClients] [bigint] NOT NULL IDENTITY(1, 1),
[uidAppUID] [uniqueidentifier] NOT NULL,
[uidClientUID] [uniqueidentifier] NOT NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_WebServicesSecurity_XREF_AppsClients_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_WebServicesSecurity_XREF_AppsClients_dteCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
