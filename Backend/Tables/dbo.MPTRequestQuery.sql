CREATE TABLE [dbo].[MPTRequestQuery]
(
[QueryId] [int] NOT NULL IDENTITY(1, 1),
[QueryName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortField] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[KeyField] [char] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldsToDisplay] [int] NOT NULL CONSTRAINT [DF_RequestQuery_FieldsToDisplay] DEFAULT ((0)),
[FieldToExclude] [int] NOT NULL CONSTRAINT [DF_RequestQuery_FieldToExclude] DEFAULT ((-1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MPTRequestQuery] ADD CONSTRAINT [PK_RequestQuery] PRIMARY KEY CLUSTERED  ([QueryId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Index of excluded field [column] {-1=None}', 'SCHEMA', N'dbo', 'TABLE', N'MPTRequestQuery', 'COLUMN', N'FieldToExclude'
GO
