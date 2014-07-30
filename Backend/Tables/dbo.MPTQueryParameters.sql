CREATE TABLE [dbo].[MPTQueryParameters]
(
[QueryName] [varchar] (64) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ParameterIndex] [int] NOT NULL,
[ParameterName] [nvarchar] (64) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ParameterOleDbType] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterOleDbType] DEFAULT ((0)),
[ParameterOracleType] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterOracleType] DEFAULT ((0)),
[ParameterSqlType] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterSqlType] DEFAULT ((0)),
[ParameterDirection] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterDirection] DEFAULT ((1)),
[ParameterSize] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterSize] DEFAULT ((0)),
[ParameterScale] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterScale] DEFAULT ((0)),
[ParameterPrecision] [int] NOT NULL CONSTRAINT [DF_MPTQueryParameters_ParameterPrecision] DEFAULT ((0)),
[ParameterDefaultValue] [nvarchar] (255) COLLATE Modern_Spanish_CI_AS NULL,
[ParameterQueryId] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MPTQueryParameters] ADD CONSTRAINT [PK_MPTQueryParameters] PRIMARY KEY CLUSTERED  ([ParameterQueryId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'{Bit=2, Char=3, Date=4, Single=5, Double=6, Image=7, Int=8, NVarChar=12, VarChar=22, SmallMoney=17, XML=25}', 'SCHEMA', N'dbo', 'TABLE', N'MPTQueryParameters', 'COLUMN', N'ParameterSqlType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la consulta a ejecutar', 'SCHEMA', N'dbo', 'TABLE', N'MPTQueryParameters', 'COLUMN', N'QueryName'
GO
