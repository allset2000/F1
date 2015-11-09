CREATE TABLE [dbo].[ROWTemplateVariables]
(
[ROWTemplateVariableId] [int] NOT NULL IDENTITY(1, 1),
[VariableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableTypeId] [int] NOT NULL,
[FieldName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Required] [bit] NOT NULL CONSTRAINT [DF_ROWTemplateVariables_Required] DEFAULT ((0)),
[ErrorCodeId] [int] NULL,
[PickList] [int] NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[ROWTemplateVariables] ADD
CONSTRAINT [FK_ROWTemplateVariables_ROWVariableTypes] FOREIGN KEY ([VariableTypeId]) REFERENCES [dbo].[ROWVariableTypes] ([ROWVariableTypeId])
GO
ALTER TABLE [dbo].[ROWTemplateVariables] ADD CONSTRAINT [PK_ROWTemplateVariables] PRIMARY KEY CLUSTERED  ([ROWTemplateVariableId]) ON [PRIMARY]
GO
