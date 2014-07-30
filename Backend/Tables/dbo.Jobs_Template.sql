CREATE TABLE [dbo].[Jobs_Template]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemplateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemplateType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duration] [smallint] NULL,
[OBX] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc] [varbinary] (max) NULL,
[Length] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Template] ADD CONSTRAINT [PK_Jobs_Template] PRIMARY KEY CLUSTERED  ([JobNumber], [TemplateName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Template] ADD CONSTRAINT [FK_Jobs_Template_Jobs] FOREIGN KEY ([JobNumber]) REFERENCES [dbo].[Jobs] ([JobNumber])
GO
