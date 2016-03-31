CREATE TABLE [dbo].[TaskType]
(
[TaskTypeID] [int] NOT NULL,
[TaskTypeName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaskType] ADD CONSTRAINT [PK_TaskType] PRIMARY KEY CLUSTERED  ([TaskTypeID]) ON [PRIMARY]
GO
