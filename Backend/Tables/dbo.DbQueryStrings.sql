CREATE TABLE [dbo].[DbQueryStrings]
(
[QueryName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SqlQueryString] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MySqlQueryString] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OleDbQueryString] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OracleQueryString] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Documentation] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DbQueryStrings] ADD CONSTRAINT [PK_DbQueryStrings] PRIMARY KEY CLUSTERED  ([QueryName]) ON [PRIMARY]
GO
