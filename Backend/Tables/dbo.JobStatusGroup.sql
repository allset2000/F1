CREATE TABLE [dbo].[JobStatusGroup]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[StatusGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobStatusGroup] ADD CONSTRAINT [PK_JobStatusOptions] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
