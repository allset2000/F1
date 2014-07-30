CREATE TABLE [dbo].[DocumentStatus]
(
[DocStatus] [smallint] NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentStatus] ADD CONSTRAINT [PK_DocumentStatus] PRIMARY KEY CLUSTERED  ([DocStatus]) ON [PRIMARY]
GO
