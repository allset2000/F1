CREATE TABLE [dbo].[JobTypeCategory]
(
[JobTypeCategoryId] [int] NOT NULL,
[JobTypeCategory] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobTypeCategory] ADD CONSTRAINT [PK_JobTypeCategory] PRIMARY KEY CLUSTERED  ([JobTypeCategoryId]) ON [PRIMARY]
GO
