CREATE TABLE [dbo].[Security_XREF_AppsUsers]
(
[intXref_AppsUsers] [bigint] NOT NULL IDENTITY(1, 1),
[uidAppUID] [uniqueidentifier] NOT NULL,
[uidUserUID] [uniqueidentifier] NOT NULL,
[intSecLevel] [int] NULL CONSTRAINT [DF_Security_XREF_AppsUsers_intSecLevel] DEFAULT ((1)),
[bitActive] [bit] NOT NULL CONSTRAINT [DF_Security_XREF_AppsUsers_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_Security_XREF_AppsUsers_dteCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
