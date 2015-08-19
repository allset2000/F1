CREATE TABLE [dbo].[ROWVariableTypes]
(
[ROWVariableTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROWVariableTypes] ADD CONSTRAINT [PK_ROWVariableTypes] PRIMARY KEY CLUSTERED  ([ROWVariableTypeId]) ON [PRIMARY]
GO
