CREATE TABLE [dbo].[Jobs_Template_History]
(
[DocumentID] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemplateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Duration] [smallint] NULL,
[OBX] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc] [varbinary] (max) NULL,
[Length] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Template_History] ADD CONSTRAINT [PK_Jobs_Template_History] PRIMARY KEY CLUSTERED  ([DocumentID]) ON [PRIMARY]
GO
