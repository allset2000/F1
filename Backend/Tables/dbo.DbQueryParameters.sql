CREATE TABLE [dbo].[DbQueryParameters]
(
[QueryName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParameterIndex] [int] NOT NULL,
[ParameterName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParameterSqlType] [int] NOT NULL,
[ParameterMySqlType] [int] NOT NULL CONSTRAINT [DF_DBQueryParameters_ParameterMySqlType] DEFAULT ((0)),
[ParameterOleDbType] [int] NOT NULL,
[ParameterOracleType] [int] NOT NULL,
[ParameterDirection] [int] NOT NULL,
[ParameterSize] [int] NOT NULL,
[ParameterScale] [int] NOT NULL,
[ParameterPrecision] [int] NOT NULL,
[ParameterDefaultValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DbQueryParameters] ADD CONSTRAINT [PK_DbQueryParameters] PRIMARY KEY CLUSTERED  ([QueryName], [ParameterIndex], [ParameterName]) ON [PRIMARY]
GO
