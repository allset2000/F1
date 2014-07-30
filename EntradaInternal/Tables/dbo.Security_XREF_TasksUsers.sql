CREATE TABLE [dbo].[Security_XREF_TasksUsers]
(
[intXref_TasksUsers] [bigint] NOT NULL IDENTITY(1, 1),
[bintTaskID] [bigint] NOT NULL,
[uidUserUID] [uniqueidentifier] NOT NULL,
[intSecLevel] [int] NULL CONSTRAINT [DF_Security_XREF_TasksUsers_intSecLevel] DEFAULT ((1)),
[bitActive] [bit] NOT NULL CONSTRAINT [DF_Security_XREF_TasksUsers_bitActive] DEFAULT ((1)),
[dteCreated] [datetime] NOT NULL CONSTRAINT [DF_Security_XREF_TasksUsers_dteCreated] DEFAULT (getdate())
) ON [PRIMARY]
GO
