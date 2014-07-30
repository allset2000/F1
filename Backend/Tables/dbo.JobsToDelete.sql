CREATE TABLE [dbo].[JobsToDelete]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsToDelete] ADD CONSTRAINT [PK_JobsToDelete] PRIMARY KEY CLUSTERED  ([JobNumber]) ON [PRIMARY]
GO
