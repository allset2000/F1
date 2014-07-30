CREATE TABLE [dbo].[WebServicesSecurity_XREF_ClientsUsers]
(
[intXref_ClientsUsers] [bigint] NOT NULL IDENTITY(1, 1),
[uidClientUID] [uniqueidentifier] NOT NULL,
[uidUserUID] [uniqueidentifier] NOT NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_WebServicesSecurity_XREF_ClientsUsers_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_WebServicesSecurity_XREF_ClientsUsers_dteCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
