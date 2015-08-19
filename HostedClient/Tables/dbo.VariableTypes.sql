CREATE TABLE [dbo].[VariableTypes]
(
[VariableTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VariableTypes] ADD CONSTRAINT [PK_VariableTypes] PRIMARY KEY CLUSTERED  ([VariableTypeId]) ON [PRIMARY]
GO
