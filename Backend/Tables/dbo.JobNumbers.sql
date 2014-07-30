CREATE TABLE [dbo].[JobNumbers]
(
[JobDate] [smalldatetime] NOT NULL,
[NumJobs] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobNumbers] ADD CONSTRAINT [PK_JobNumbers] PRIMARY KEY CLUSTERED  ([JobDate]) ON [PRIMARY]
GO
